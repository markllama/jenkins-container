#!/bin/sh
# http://sam.gleske.net/blog/engineering/2016/05/04/jenkins-with-ssl.html

# This can be easier:
# keytool -genkey -alias ystore jenkins.key -keysize 2048
# From https://www.sans.org/reading-room/whitepapers/bestprac/securing-jenkins-ci-systems-36872
# add -dname "c=US, cd=<name>, o=Red Hat Inc., ou=Engineering CD, ...

CN=${CN:-server}
DNSDOMAIN=${DNSDOMAIN:-lamourine.homeunix.org}
FQDN=${CN}.${DNSDOMAIN}
KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD:-"badpassword"}


SUBJ="/C=US/ST=Massachusetts/L=Billerica/O=lamourine/OU=parent/CN=${FQDN}"


function create_self_signed_cert() {
    openssl req -x509 -newkey rsa:4096 -days 1825 -nodes \
            -keyout ${CN}-key.pem -out ${CN}-cert.pem \
            -subj "${SUBJ}"
}

function create_pkcs_file() {
    openssl pkcs12 -export -out ${CN}.p12 -inkey ${CN}-key.pem \
            -passout "pass:${KEYSTORE_PASSWORD}" \
            -in ${CN}-cert.pem -certfile ${CN}-cert.pem -name ${FQDN}
}

function create_keystore() {
    keytool -importkeystore -srckeystore ${CN}.p12 \
            -srcstorepass "${KEYSTORE_PASSWORD}" -srcstoretype PKCS12 \
            -srcalias ${FQDN} -deststoretype PKCS12 \
            -destkeystore ${CN}.jks -deststorepass "${KEYSTORE_PASSWORD}" \
            -destalias ${FQDN}
}

create_self_signed_cert
create_pkcs_file
create_keystore
