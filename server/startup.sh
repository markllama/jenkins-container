#!/bin/sh

[ -z "$SERVER_FQDN" ] && echo "Missing required value: SERVER_FQDN" && exit 2
[ -z "$ADMIN_EMAIL" ] && echo "Missing required value: ADMIN_EMAIL" && exit 2

# From container environment
: "${JENKINS_ROOT:=/jenkins}"
: "${JENKINS_HOME:=${JENKINS_ROOT}/config}"
: "${JENKINS_WAR:=/usr/lib/jenkins/jenkins.war}"
: "${JENKINS_USER:=jenkins}"
: "${JENKINS_UID:=$(id -u ${JENKINS_USER})}"
: "${JENKINS_GROUP:=jenkins}"
: "${JENKINS_GID:=$(id -u ${JENKINS_GROUP})}"
: "${HTTPS_PORT:=8443}"
: "${HTTPS_LISTEN_ADDRESS:=0.0.0.0}"
: "${HTTPS_KEYSTORE:=${JENKINS_ROOT}/keystore.jks}"
: "${HTTPS_KEYSTORE_PASSWORD:=${KEYSTORE_PASSWORD}}"

: "${JAVA_ARGS:=Dcom.sun.akuma.Daemon=daemonized
-Djava.awt.headless=true
-Djava.net.preferIPv4Stack=true
-Djenkins.install.runSetupWizard=false
-Djenkins.branch.WorkspaceLocatorImpl.PATH_MAX=0
-DJENKINS_HOME=${JENKINS_HOME}}"

HTTPS_CONFIG="--httpPort=-1 
--httpsPort=${HTTPS_PORT}
--httpsListenAddress=${HTTPS_LISTEN_ADDRESS}
--httpsKeyStore=${HTTPS_KEYSTORE}
--httpsKeyStorePassword=${HTTPS_KEYSTORE_PASSWORD}"

echo "--- $(date --rfc-3339=seconds) PREPARING CONTAINER ---"

if [ $JENKINS_UID -ne $(id -u ${JENKINS_USER}) ] ; then
    usermod -u ${JENKINS_UID} ${JENKINS_USER}
fi

if [ $JENKINS_GID -ne $(id -g ${JENKINS_USER}) ] ; then
    groupmod -g ${JENKINS_GID} ${JENKINS_GROUP}
fi

[ -d ${JENKINS_ROOT}/var/builds ] || mkdir -p ${JENKINS_ROOT}/var/builds
[ -d ${JENKINS_ROOT}/var/workspaces ] || mkdir -p ${JENKINS_ROOT}/var/workspaces

/usr/bin/sed \
    -i \
    -e "/buildsDir/s|>.*<|>$JENKINS_ROOT/var/builds/\${ITEM_FULL_NAME}<|" \
    -e "/workspaceDir/s|>.*<|>$JENKINS_ROOT/var/workspaces/\${ITEM_FULL_NAME}<|" \
    ${JENKINS_HOME}/config.xml

/usr/bin/sed \
    -i \
    -e "/jenkinsUrl/s|>.*<|>${SERVER_FQDN}<|" \
    -e "/adminAddress/s|>.*<|>${ADMIN_EMAIL}<|" \
    ${JENKINS_HOME}/jenkins.model.JenkinsLocationConfiguration.xml

chown -R ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_HOME}
chown ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_ROOT}/backups
chown ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_ROOT}/secrets
chown ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_ROOT}/var/builds
chown ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_ROOT}/var/workspaces

cd ${JENKINS_HOME}

# Enable master/slave security 
cat > secrets/slave-to-master-security-kill-switch <<EOF
false
EOF

echo "--- $(date --rfc-3339=seconds) STARTING JENKINS ---"

exec gosu ${JENKINS_USER} \
     /usr/bin/java ${JAVA_ARGS} -jar ${JENKINS_WAR} ${HTTPS_CONFIG}
