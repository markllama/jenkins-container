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

ARG JENKINS_ROOT=/jenkins
ARG JENKINS_AGENT_WORKDIR=$JENKINS_ROOT/agent

ENV JENKINS_USER="jenkins" \
    JENKINS_GROUP="jenkins"

RUN mkdir -p $JENKINS_WORKDIR

ADD startup.sh /jenkins/startup.sh
RUN chmod a+x /jenkins/startup.sh

RUN curl https://pkg.jenkins.io/redhat/jenkins.repo \
    > /etc/yum.repos.d/jenkins.repo ; \
    rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

RUN yum -y install java-1.8.0-openjdk git ; \
    yum -y clean all ; rm -rf /var/cache/yum

ENV MASTER_URL="" \
    SECRET="" \
    AGENT_NAME="" \
    AGENT_WORKDIR=$JENKINS_AGENT_WORKDIR \

VOLUME $JENKINS_WORKDIR

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD /jenkins/startup.sh
