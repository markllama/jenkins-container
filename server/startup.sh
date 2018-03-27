#!/bin/sh

# From container environment
JENKINS_HOME=${JENKINS_HOME:-"/jenkins"}
JENKINS_WAR=${JENKINS_WAR:-"/usr/lib/jenkins/jenkins.war"}
HTTPS_PORT=${HTTPS_PORT:-8443}
HTTPS_LISTEN_ADDRESS=${HTTPS_LISTEN_ADDRESS:-0.0.0.0}
HTTPS_KEYSTORE=${HTTPS_KEYSTORE:-${JENKINS_HOME}/keystore.jks}
HTTPS_KEYSTORE_PASSWORD=${HTTPS_KEYSTORE_PASSWORD:-${KEYSTORE_PASSWORD}}

JAVA_ARGS=${JAVA_ARGS:-"-Dcom.sun.akuma.Daemon=daemonized
-Djava.awt.headless=true
-Djava.net.preferIPv4Stack=true
-Djenkins.install.runSetupWizard=false
-Djenkins.branch.WorkspaceLocatorImpl.PATH_MAX=0
-DJENKINS_HOME=${JENKINS_HOME}"}

HTTPS_CONFIG="--httpPort=-1 
--httpsPort=${HTTPS_PORT}
--httpsListenAddress=${HTTPS_LISTEN_ADDRESS}
--httpsKeyStore=${HTTPS_KEYSTORE}
--httpsKeyStorePassword=${HTTPS_KEYSTORE_PASSWORD}"

cd ${JENKINS_HOME}
exec /usr/bin/java ${JAVA_ARGS} -jar ${JENKINS_WAR} ${HTTPS_CONFIG}
