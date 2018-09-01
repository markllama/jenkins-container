#!/bin/sh

set -x

[ -z "${MASTER_SERVER}" ] && echo "missing required value MASTER_SERVER" && exit 2
: "${MASTER_PORT:=8443}"
[ -z "${AGENT_NAME}" ] && echo "missing required value AGENT_NAME" && exit 2
: "${AGENT_SECRET:=''}"
#: "${AGENT_PORT:=35124}"

: "${KRB5_REALM}:=''}"
: "${KRB5_KDC}:=''}"
: "${KRB5_ADMIN_SERVER}:=''}"

: "${GIT_USER:='Jenkins Master Admin'}"
: "${GET_EMAIL='jenkins@example.com'}"

: "${JENKINS_ROOT:=/jenkins}"
: "${JENKINS_HOME:=${JENKINS_ROOT}/agent}"
: "${JENKINS_SSH_DIR:=${JENKINS_HOME}/.ssh}"

: "${JENKINS_USER:=jenkins}"
: "${JENKINS_UID:=$(id -u ${JENKINS_USER})}"
: "${JENKINS_GROUP:=jenkins}"
: "${JENKINS_GID:=$(id -u ${JENKINS_GROUP})}"

: "${JENKINS_AGENT_JAR_URL:=https://${MASTER_SERVER}:${MASTER_PORT}/jnlpJars/agent.jar}"
: "${JENKINS_AGENT_JAR:=${JENKINS_ROOT}/agent.jar}"

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


SERVER_URL=https://${MASTER_SERVER}:${MASTER_PORT}
JAVAWS_URL=${SERVER_URL}/computer/${AGENT_NAME}/slave-agent.jnlp

[ -n "${AGENT_SECRET}" ] && SECRET_ARG="-secret ${AGENT_SECRET}"
: "${JENKINS_AGENT_ARGS:=-noCertificateCheck
     -jnlpUrl ${JAVAWS_URL}
     -workDir ${JENKINS_HOME}
     ${SECRET_ARG}}"

[ $JENKINS_UID -ne $(id -u ${JENKINS_USER}) ] && \
    usermod -u ${JENKINS_UID} ${JENKINS_USER}
[ $JENKINS_GID -ne $(id -g ${JENKINS_USER}) ] &&
    groupmod -g ${JENKINS_GID} ${JENKINS_GROUP}
chown -R jenkins:jenkins ${JENKINS_HOME}

ls -laZ ${JENKINS_HOME}
ls -lZ ${JENKINS_SSH_DIR}

cat <<EOF > ~jenkins/.gitconfig
[user]
  name = ${GIT_USER}
  email = ${GIT_EMAIL}

[push]
  default = simple
EOF

curl --insecure --silent ${JENKINS_AGENT_JAR_URL} > ${JENKINS_AGENT_JAR}

# Error if the curl fails
cd ${JENKINS_HOME}
exec gosu ${JENKINS_USER} \
     /usr/bin/java -jar ${JENKINS_AGENT_JAR} ${JENKINS_AGENT_ARGS}
