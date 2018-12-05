# A Jenkins Slave using JNLP
FROM centos
#FROM rhel7

ARG TINI_VERSION=v0.18.0
ARG TINI_URL=https://github.com/krallin/tini/releases/download/
ADD $TINI_URL/$TINI_VERSION/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ARG GOSU_VERSION=1.10
ARG GOSU_URL=https://github.com/tianon/gosu/releases/download
ADD $GOSU_URL/$GOSU_VERSION/gosu-amd64 /usr/bin/gosu
RUN chmod a+x /usr/bin/gosu

ARG EPEL_RELEASE_RPM=https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN if grep -q 'Red Hat Enterprise Linux' /etc/redhat-release ; then \
      yum -y install ${EPEL_RELEASE_RPM} ;\
    else \
      yum -y install epel-release ; \
    fi ; \
    yum -y clean all ; rm -rf /var/cache/yum

RUN grep -q 'Red Hat Enterprise Linux' /etc/redhat-release && \
    yum-config-manager --enable rhel-7-server-extras-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms

RUN yum -y install java-1.8.0-openjdk git krb5-workstation ; \
    yum -y clean all ; rm -rf /var/cache/yum

ARG BUILD_PACKAGES="golang go-bindata tito npm nodejs-grunt-cli docker groovy bsdtar krb5-devel make which"
RUN yum -y install ${BUILD_PACKAGES} ; \
    yum -y clean all ; rm -rf /var/cache/yum

# This is a requirement for building an RPM.  Dunno why.
ARG REMOTE_PACKAGES="http://cbs.centos.org/kojifiles/packages/goversioninfo/0.1/1.el7/x86_64/goversioninfo-0.1-1.el7.x86_64.rpm"
RUN yum -y install ${REMOTE_PACKAGES} ; \
    yum -y clean all ; rm -rf /var/cache/yum

ARG RCM_TOOLS_URL=http://download.devel.redhat.com/rel-eng/RCMTOOLS
ARG RCM_TOOLS_REPO_FILE=rcm-tools-rhel-7-server.repo
ADD ${RCM_TOOLS_URL}/${RCM_TOOLS_REPO_FILE} /etc/yum.repos.d/${RCM_TOOLS_REPO_FILE}
RUN yum -y install brewkoji rhpkg ; \
    yum -y clean all ; rm -rf /var/cache/yum

# Now some.. stuff to make stuff build. Don't ask.
ARG GO_SHIM_URL=http://download.eng.bos.redhat.com/brewroot/packages/golang-scl-shim/1.10.2/5.el7/x86_64/golang-scl-shim-1.10.2-5.el7.x86_64.rpm
# Only do this on RHEL
RUN grep -q 'Red Hat Enterprise Linux' /etc/redhat-release || exit ; \
    yum-config-manager --enable rhel-7-server-devtools-rpms ; \
    yum-config-manager --enable rhel-server-rhscl-7-rpms ; \
    yum -y install ${GO_SHIM_URL} ; \
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

