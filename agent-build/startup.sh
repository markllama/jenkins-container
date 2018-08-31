#!/bin/sh

set -x

[ -z "${MASTER_SERVER}" ] && echo "missing required value MASTER_SERVER" && exit 2
: "${MASTER_PORT:=8443}"
[ -z "${AGENT_NAME}" ] && echo "missing required value AGENT_NAME" && exit 2
: "${AGENT_SECRET:=''}"
#: "${AGENT_PORT:=35124}"

: "${JENKINS_ROOT:=/jenkins}"
: "${JENKINS_HOME:=${JENKINS_ROOT}/agent}"
: "${JENKINS_SSH_DIR:=${JENKINS_HOME}/.ssh}"

: "${JENKINS_USER:=jenkins}"
: "${JENKINS_UID:=$(id -u ${JENKINS_USER})}"
: "${JENKINS_GROUP:=jenkins}"
: "${JENKINS_GID:=$(id -u ${JENKINS_GROUP})}"

: "${JENKINS_AGENT_JAR_URL:=https://${MASTER_SERVER}:${MASTER_PORT}/jnlpJars/agent.jar}"
: "${JENKINS_AGENT_JAR:=${JENKINS_ROOT}/agent.jar}"

SERVER_URL=https://${MASTER_SERVER}:${MASTER_PORT}
JAVAWS_URL=${SERVER_URL}/computer/${AGENT_NAME}/slave-agent.jnlp

[ -n "${AGENT_SECRET}" ] && SECRET_ARG="-secret ${AGENT_SECRET}"
: "${JENKINS_AGENT_ARGS:=-noCertificateCheck
     -jnlpUrl ${JAVAWS_URL}
     -workDir ${JENKINS_HOME}
     ${SECRET_ARG}}"

: "${GIT_NAME:='Jenkins Agent'}"
: "${GIT_EMAIL:='jenkins@${MASTER_SERVER}'}"

if [ -n "${KRB5_REALM}" ] ; then

    sed -i -e '/default_ccache_name/s/^/#/' /etc/krb5.conf
    sed -i -e "/default_realm/s/^.*$/ default_realm = ${KRB5_REALM}/" /etc/krb5.conf
    cat <<EOF > /etc/krb5.conf.d/${KRB5_REALM}.conf
[realms]
${KRB5_REALM} = {
   kdc = ${KRB5_KDC}
   admin_server = ${KRB5_ADMIN_SERVER}
}
EOF
fi

[ $JENKINS_UID -ne $(id -u ${JENKINS_USER}) ] && \
    usermod -u ${JENKINS_UID} ${JENKINS_USER}
[ $JENKINS_GID -ne $(id -g ${JENKINS_USER}) ] &&
    groupmod -g ${JENKINS_GID} ${JENKINS_GROUP}

chown -R jenkins:jenkins ${JENKINS_HOME}

if [ -n "${DOCKER_GID}" ] ; then
    sed -i -e 's/dockerroot/docker/' /etc/passwd
    sed -i -e 's/dockerroot/docker/' /etc/group
    groupmod -g ${DOCKER_GID} docker
    usermod --append --groups docker ${JENKINS_USER}
fi

curl --insecure --silent ${JENKINS_AGENT_JAR_URL} > ${JENKINS_AGENT_JAR}

# Error if the curl fails
cd ${JENKINS_HOME}
exec gosu ${JENKINS_USER} \
     /usr/bin/java -jar ${JENKINS_AGENT_JAR} ${JENKINS_AGENT_ARGS}
