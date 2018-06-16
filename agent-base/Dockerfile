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

RUN yum -y install java-1.8.0-openjdk git krb5-workstation \
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

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD /jenkins/startup.sh

