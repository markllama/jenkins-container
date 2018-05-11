# A Jenkins server
FROM centos
#FROM rhel7

ARG TINI_VERSION=v0.17.0
ARG TINI_URL=https://github.com/krallin/tini/releases/download/
ADD $TINI_URL/$TINI_VERSION/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ARG GOSU_VERSION=1.10
ARG GOSU_URL=https://github.com/tianon/gosu/releases/download
ADD $GOSU_URL/$GOSU_VERSION/gosu-amd64 /usr/bin/gosu
RUN chmod a+x /usr/bin/gosu

ARG JENKINS_ROOT="/jenkins"
ARG JENKINS_HTTPS_PORT=8443

ENV JENKINS_HOME="$JENKINS_ROOT/config" \
    JENKINS_WAR="/usr/lib/jenkins/jenkins.war" \
    JENKINS_USER="jenkins" \
    JENKINS_GROUP="jenkins" \
    HTTPS_PORT=$JENKINS_HTTPS_PORT \
    HTTPS_LISTEN_ADDRESS=0.0.0.0 \
    JAVA_ARGS="-Dcom.sun.akuma.Daemon=daemonized \
    -Djava.awt.headless=true \
    -Djava.net.preferIPv4Stack=true \
    -Djenkins.install.runSetupWizard=false \
    -Djenkins.branch.WorkspaceLocatorImpl.PATH_MAX=0"

RUN curl https://pkg.jenkins.io/redhat/jenkins.repo \
    > /etc/yum.repos.d/jenkins.repo ; \
    rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

RUN yum -y install java-1.8.0-openjdk jenkins git krb5-workstation; \
    yum -y install patch ; \
    yum -y clean all ; rm -rf /var/cache/yum

RUN mkdir -p /jenkins/{backups,bin,config,var}  ; \
    ln -s $JENKINS_ROOT/secrets $JENKINS_ROOT/config/secrets

ADD install_plugins.sh /jenkins/install_plugins.sh
ADD jenkins-plugins.txt /jenkins/plugins.txt
RUN /bin/sh /jenkins/install_plugins.sh

ADD startup.sh /jenkins/startup.sh
RUN chmod a+x /jenkins/startup.sh

RUN cp /jenkins/config/config.xml /jenkins/config/config.xml.orig

RUN /usr/bin/sed -i \
    -e "/buildsDir/s|>.*<|>$JENKINS_ROOT/var/builds/\${ITEM_FULL_NAME}<|" \
    -e "/workspaceDir/s|>.*<|>$JENKINS_ROOT/var/workspace/\${ITEM_FULL_NAME}<|" \
    ${JENKINS_HOME}/config.xml
    
ADD init/* /jenkins/config/
RUN patch < /jenkins/config/01-config.xml-csrf.patch /jenkins/config/config.xml
RUN patch < /jenkins/config/02-config.xml-safe-agent-protocols.patch \
    /jenkins/config/config.xml
ADD init/baseurl/* /jenkins/config/
RUN patch < /jenkins/config/03-config.xml-quiet.patch /jenkins/config/config.xml
RUN patch < /jenkins/config/04-config.xml-security.patch \
    /jenkins/config/config.xml
RUN patch < /jenkins/config/05-config.xml-rbac.patch \
    /jenkins/config/config.xml
RUN patch < /jenkins/config/06-config.xml-root-check.patch \
    /jenkins/config/config.xml

RUN mkdir -p /jenkins/config/users/admin
ADD init/users/admin.xml /jenkins/config/users/admin/config.xml

ADD periodicBackup.xml /jenkins/config/periodicBackup.xml

# Location of the keystore
VOLUME /jenkins/var/backups
VOLUME /jenkins/var/builds
VOLUME /jenkins/var/workspace
VOLUME /jenkins/secrets
VOLUME /jenkins/keystore.jks

EXPOSE $JENKINS_HTTPS_PORT

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD /jenkins/startup.sh
