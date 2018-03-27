#!/bin/sh

# From container environment
JENKINS_HOME=${JENKINS_HOME:-"/jenkins"}
JENKINS_WAR=${JENKINS_WAR:-"/usr/lib/jenkins/jenkins.war"}

JAVA_ARGS=${JAVA_ARGS:-"-Dcom.sun.akuma.Daemon=daemonized 
-Djava.awt.headless=true 
-Djava.net.preferIPv4Stack=true
-Djenkins.install.runSetupWizard=false \
-Djenkins.branch.WorkspaceLocatorImpl.PATH_MAX=0
-DJENKINS_HOME=${JENKINS_HOME}"}

# Only for plugin installation
HTTP_PORT=${HTTP_PORT:-8080}
HTTP_LISTEN_ADDRESS=${HTTP_LISTEN_ADDRESS:-127.0.0.1}
HTTP_CONFIG="--httpPort=${HTTP_PORT} --httpListenAddress=${HTTP_LISTEN_ADDRESS}"

# =============================================================================
# Main
# =============================================================================

# Start the service on a local address and port for CLI access
cd ${JENKINS_HOME}

/usr/bin/java ${JAVA_ARGS} -jar ${JENKINS_WAR} ${HTTP_CONFIG} &
sleep 10

# Pull the CLI jar file from the running server
curl http://${HTTP_LISTEN_ADDRESS}:${HTTP_PORT}/jnlpJars/jenkins-cli.jar \
     > ${JENKINS_HOME}/jenkins-cli.jar

# Load the plugins listed in the plugins.txt file
for PLUGIN in $(cat /jenkins/plugins.txt) ; do
    java -jar ${JENKINS_HOME}/jenkins-cli.jar -s http://127.0.0.1:8080 \
         install-plugin $PLUGIN
done

# kill the local private service and move on
pkill java

