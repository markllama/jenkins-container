# A Jenkins Slave using JNLP
FROM centos

ARG TINI_VERSION=v0.17.0
ARG TINI_URL=https://github.com/krallin/tini/releases/download/
ADD $TINI_URL/$TINI_VERSION/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ARG GOSU_VERSION=1.10
ARG GOSU_URL=https://github.com/tianon/gosu/releases/download
ADD $GOSU_URL/$GOSU_VERSION/gosu-amd64 /usr/bin/gosu
RUN chmod a+x /usr/bin/gosu

RUN yum -y install epel-release \
    yum -y clean all ; rm -rf /var/cache/yum

RUN yum -y install java-1.8.0-openjdk git krb5-workstation \
    yum -y clean all ; rm -rf /var/cache/yum

ARG BUILD_PACKAGES="golang tito npm nodejs-grunt-cli docker"
RUN yum -y install ${BUILD_PACKAGES} \
    yum -y clean all ; rm -rf /var/cache/yum

ARG RCM_TOOLS_URL=http://download.devel.redhat.com/rel-eng/RCMTOOLS
ARG RCM_TOOLS_REPO_FILE=rcm-tools-rhel-7-server.repo
ADD ${RCM_TOOLS_URL}/${RCM_TOOLS_REPO_FILE} /etc/yum.repos.d/${RCM_TOOLS_REPO_FILE}
RUN yum -y install brewkoji \
    yum -y clean all ; rm -rf /var/cache/yum

ARG JENKINS_ROOT="/jenkins"
ARG JENKINS_HOME=${JENKINS_ROOT}/agent
ARG JENKINS_SSH_DIR=${JENKINS_HOME}.ssh

ENV JENKINS_USER="jenkins" \
    JENKINS_GROUP="jenkins"

RUN mkdir -p ${JENKINS_ROOT}
RUN useradd --create-home --home-dir ${JENKINS_ROOT}/agent \
  --comment "Jenkins Agent User" \
  --shell /bin/false \
  --password '*' jenkins

#RUN mkdir -p ${JENKINS_SSH_DIR} \
#    chmod 600 ${JENKINS_SSH_DIR}

ADD startup.sh ${JENKINS_ROOT}/startup.sh

VOLUME ${JENKINS_SSH_DIR}

# Mount host docker inside the container
VOLUME /var/run/docker.sock

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD /jenkins/startup.sh

