# A Jenkins Slave using JNLP
FROM centos

RUN yum -y install java-1.8.0-openjdk git \
    yum -y clean all ; rm -rf /var/cache/yum

RUN mkdir -p /jenkins/agent
ADD startup.sh /jenkins/startup.sh
CMD /jenkins/startup.sh
