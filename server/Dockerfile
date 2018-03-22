# A Jenkins server
#FROM centos
FROM rhel7

RUN curl https://pkg.jenkins.io/redhat/jenkins.repo \
    > /etc/yum.repos.d/jenkins.repo ; \
    rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

RUN yum -y install java-1.8.0-openjdk jenkins ; \
    yum -y clean all ; rm -rf /var/cache/yum

ADD jenkins.sh /start.sh

# Location of the working data
#VOLUME /var/lib/jenkins

# Location of the keystore
#VOLUME /jenkins.jks

EXPOSE 8443
EXPOSE 8080

#USER jenkins

CMD /usr/bin/sh /start.sh
