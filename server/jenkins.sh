#!/bin/sh

#JENKINS_PORT=
#JENKINS_LISTEN_ADDRESS=
#
#JENKINS_HTTPS_PORT= --http
#JENKINS_HTTPS_LISTEN_ADDRESS
#JENKINS_HTTPS_KEYSTORE=
#JENKINS_HTTPS_KEYSTORE_PASSWORD=

#JENKINS_LOGFILE
#JENKINS_WEBROOT

# -- JENKINS
# JENKINS_JAVA_OPTIONS
# JENKINS_LISTEN_ADDRESS
# JENKINS_ARGS

# Check file jenkins.jks
# Check password is provided

JENKINS_HOME=/jenkins

JAVA_ARGS="-Dcom.sun.akuma.Daemon=daemonized 
-Djava.awt.headless=true 
-Djava.net.preferIPv4Stack=true
-Djenkins.install.runSetupWizard=false \
-Djenkins.branch.WorkspaceLocatorImpl.PATH_MAX=0
-DJENKINS_HOME=${JENKINS_HOME}"

JENKINS_WAR="/usr/lib/jenkins/jenkins.war"

HTTP_CONFIG="--httpPort=8080 --httpListenAddress=127.0.0.1"

HTTPS_CONFIG="--httpPort=-1 
--httpsPort=8443 
--httpsKeyStore=${JENKINS_HOME}/keystore.jks
--httpsKeyStorePassword=${KEYSTORE_PASSWORD}"


function kill_jenkins() {
    pkill java
}

function get_cli() {
    curl http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar \
         > ${JENKINS_HOME}/jenkins-cli.jar
}

# java -jar /jenkins/jenkins-cli.jar -noCertificateCheck -s https://127.0.0.1:8443 install-plugin
function install_plugins() {
    for PLUGIN in $(cat /jenkins/plugins.txt) ; do
        java -jar ${JENKINS_HOME}/jenkins-cli.jar -s http://127.0.0.1:8080 \
             install-plugin $PLUGIN
    done
}

function run_jenkins_setup() {
    /usr/bin/java ${JAVA_ARGS} -jar ${JENKINS_WAR} ${HTTP_CONFIG} &
    sleep 10

    get_cli
    install_plugins
    kill_jenkins
}

function run_jenkins_service() {
    exec /usr/bin/java ${JAVA_ARGS} -jar ${JENKINS_WAR} ${HTTPS_CONFIG}
}


if [ "$1" == "daemon" ] ; then
    run_jenkins_service
else
    run_jenkins_setup
fi
