# A Jenkins server
#FROM centos
FROM rhel7

RUN curl https://pkg.jenkins.io/redhat/jenkins.repo \
    > /etc/yum.repos.d/jenkins.repo ; \
    rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

RUN yum -y install java-1.8.0-openjdk jenkins ; \
    yum -y clean all ; rm -rf /var/cache/yum

RUN mkdir /jenkins ; chown jenkins:jenkins /jenkins
RUN mkdir /backups ; chown jenkins:jenkins /backups

ADD jenkins.sh /jenkins/start.sh
ADD jenkins-plugins.txt /jenkins/plugins.txt

RUN /bin/sh /jenkins/start.sh ; chown -R jenkins:jenkins /jenkins

# Location of the keystore
VOLUME /jenkins/keystore.jks

EXPOSE 8443
# EXPOSE 8080

USER jenkins

CMD /bin/sh /jenkins/start.sh daemon
