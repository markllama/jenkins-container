#!/bin/sh

set -x

[ -z "${MASTER_SERVER}" ] && echo "missing required value MASTER_SERVER" && exit 2
: "${MASTER_PORT:=8443}"
[ -z "${AGENT_NAME}" ] && echo "missing required value AGENT_NAME" && exit 2
: "${AGENT_SECRET:=''}"
: "${JENKINS_USER:=jenkins}"
: "${JENKINS_UID:=$(id -u ${JENKINS_USER})}"
: "${JENKINS_GROUP:=jenkins}"
: "${JENKINS_GID:=$(id -u ${JENKINS_GROUP})}"


SERVER_URL=https://${MASTER_SERVER}:${MASTER_PORT}
JARFILE_URL=${SERVER_URL}/computer/${AGENT_NAME}/slave-agent.jnlp

[ -n "${AGENT_SECRET}" ] && SECRET_ARG="-secret ${AGENT_SECRET}"

if [ $JENKINS_UID -ne $(id -u ${JENKINS_USER}) ] ; then
    usermod -u ${JENKINS_UID} ${JENKINS_USER}
fi

if [ $JENKINS_GID -ne $(id -g ${JENKINS_USER}) ] ; then
    groupmod -g ${JENKINS_GID} ${JENKINS_GROUP}
fi

cd /jenkins

curl --insecure --silent \
     https://${MASTER_SERVER}:${MASTER_PORT}/jnlpJars/agent.jar \
     > /jenkins/agent.jar

# Error if the curl fails

exec java -jar /jenkins/agent.jar \
     -noCertificateCheck \
     -jnlpUrl ${JARFILE_URL} \
     -workDir "/jenkins/agent" \
     ${SECRET_ARG}
