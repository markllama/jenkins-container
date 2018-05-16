#!/bin/sh

[ -z "$MASTER_SERVER" ] && echo "missing required value MASTER_SERVER" && exit 2
: ${MASTER_PORT:=8443}
[ -z "$AGENT_NAME" ] && echo "missing required value AGENT_NAME" && exit 2
: ${AGENT_SECRET:=""}

SERVER_URL=https://${MASTER_SERVER}:${MASTER_PORT}
JARFILE_URL=${SERVER_URL}/computer/${AGENT_NAME}/slave-agent.jnlp

cd /jenkins

curl --insecure --silent \
     https://${MASTER_SERVER}:${MASTER_PORT}/jnlpJars/agent.jar \
     > /jenkins/agent.jar

# Error if the curl fails

exec java -jar /jenkins/agent.jar \
     -noCertificateCheck \
     ${JARFILE_URL} \
     -workDir "/jenkins/agent"
