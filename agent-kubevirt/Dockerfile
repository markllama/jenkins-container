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
ARG CLOUD_CLI_RPMS="awscli gcloud"
RUN yum -y install ${CLOUD_CLI_RPMS} ; \
    yum -y clean all ; rm -rf /var/cache/yum

# systemd setup from https://github.com/projectatomic/docker-image-examples/blob/master/rhel-libvirt/libvirtd/Dockerfile

# RUN rpm -e --nodeps fakesystemd
ARG KVM_PACKAGES="systemd libvirt libvirt-daemon qemu-kvm"
RUN yum -y install ${KVM_PACKAGES} ; \
    yum -y clean all ; rm -rf /var/cache/yum ; \
    
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    systemctl enable libvirtd; \
    systemctl enable virtlockd 

EXPOSE 16509

RUN echo "listen_tls = 0" >> /etc/libvirt/libvirtd.conf; \
echo 'listen_tcp = 1' >> /etc/libvirt/libvirtd.conf; \
echo 'tls_port = "16514"' >> /etc/libvirt/libvirtd.conf; \ 
echo 'tcp_port = "16509"' >> /etc/libvirt/libvirtd.conf; \
echo 'auth_tcp = "none"' >> /etc/libvirt/libvirtd.conf

RUN echo 'LIBVIRTD_ARGS="--listen"' >> /etc/sysconfig/libvirtd
RUN mkdir -p /var/lib/libvirt/images/

# Edit the service file which includes ExecStartPost to chmod /dev/kvm
RUN sed -i "/Service/a ExecStartPost=\/bin\/chmod 666 /dev/kvm" /usr/lib/systemd/system/libvirtd.service
ARG KUBE_PACKAGES="kubernetes-client"
RUN yum -y install ${KUBE_PACKAGES} ; \
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

RUN sed -i -e '/^libvirt/s/:$/:jenkins/' /etc/group

#RUN mkdir -p ${JENKINS_SSH_DIR} \
#    chmod 600 ${JENKINS_SSH_DIR}

ADD startup.sh ${JENKINS_ROOT}/startup.sh

VOLUME ${JENKINS_SSH_DIR}

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD /jenkins/startup.sh

