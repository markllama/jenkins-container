# A Jenkins Slave using JNLP
FROM centos
#FROM rhel7

ARG TINI_VERSION=v0.18.0
ARG TINI_URL=https://github.com/krallin/tini/releases/download/
ADD $TINI_URL/$TINI_VERSION/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ARG GOSU_VERSION=1.11
ARG GOSU_URL=https://github.com/tianon/gosu/releases/download
ADD $GOSU_URL/$GOSU_VERSION/gosu-amd64 /usr/bin/gosu
RUN chmod a+x /usr/bin/gosu

ARG BASE_PACKAGES="which"
RUN yum -y install ${BASE_PACKAGES} ; \
    yum -y clean all ; rm -rf /var/cache/yum

ARG EPEL_RELEASE_RPM=https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN if grep -q 'Red Hat Enterprise Linux' /etc/redhat-release ; then \
      yum -y install ${EPEL_RELEASE_RPM} ;\
    else \
      yum -y install epel-release ; \
    fi ; \
    yum -y clean all ; rm -rf /var/cache/yum

RUN yum -y install java-1.8.0-openjdk git krb5-workstation ; \
    yum -y clean all ; rm -rf /var/cache/yum

# Enable cloud CLI commands
ADD google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
ARG CLOUD_CLI_RPMS="awscli google-cloud-sdk"
RUN yum -y install ${CLOUD_CLI_RPMS} ; \
    yum -y clean all ; rm -rf /var/cache/yum

# Add old linkchecker since CentOS doesn't have an RPM for it
ARG LINKCHECKER_RPM_URL=https://kojipkgs.fedoraproject.org//packages/linkchecker/8.6/2.fc21/x86_64/linkchecker-8.6-2.fc21.x86_64.rpm
RUN yum install -y ${LINKCHECKER_RPM_URL} ; \
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

