# A Jenkins server
#FROM centos
FROM rhel7

ENV JENKINS_HOME="/jenkins" \
    JENKINS_WAR="/usr/lib/jenkins/jenkins.war" \
    HTTPS_PORT=8443 \
    HTTPS_LISTEN_ADDRESS=0.0.0.0 \
    JAVA_ARGS="-Dcom.sun.akuma.Daemon=daemonized \
    -Djava.awt.headless=true \
    -Djava.net.preferIPv4Stack=true \
    -Djenkins.install.runSetupWizard=false \
    -Djenkins.branch.WorkspaceLocatorImpl.PATH_MAX=0 \
    -DJENKINS_HOME=${JENKINS_HOME}"

RUN curl https://pkg.jenkins.io/redhat/jenkins.repo \
    > /etc/yum.repos.d/jenkins.repo ; \
    rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

RUN yum -y install java-1.8.0-openjdk jenkins git krb5-workstation ; \
    yum -y clean all ; rm -rf /var/cache/yum

RUN mkdir /jenkins ; chown jenkins:jenkins /jenkins ; \
    mkdir /backups ; chown jenkins:jenkins /backups

ADD install_plugins.sh /jenkins/install_plugins.sh
ADD jenkins-plugins.txt /jenkins/plugins.txt

RUN /bin/sh /jenkins/install_plugins.sh ; chown -R jenkins:jenkins /jenkins

# Location of the keystore
VOLUME /jenkins/keystore.jks

#EXPOSE ${HTTPS_PORT}
EXPOSE 8443

ADD startup.sh /jenkins/startup.sh

USER jenkins

CMD /bin/sh /jenkins/startup.sh daemon
