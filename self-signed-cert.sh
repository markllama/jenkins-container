#!/bin/sh
# http://sam.gleske.net/blog/engineering/2016/05/04/jenkins-with-ssl.html

CN=hp-blade15
FQDN=${CN}.cd.e2e.bos.redhat.com
PASSWORD="secret1"


SUBJ="/C=US/ST=Massachusetts/L=Westford/O=Red Hat Inc./OU=Eng CD/CN=${FQDN}"


function create_self_signed_cert() {
    openssl req -x509 -newkey rsa:4096 -days 1825 -nodes \
            -keyout ${CN}-key.pem -out ${CN}-cert.pem \
            -subj "${SUBJ}"
}

function create_pkcs_file() {
    openssl pkcs12 -export -out ${CN}.p12 -inkey ${CN}-key.pem \
            -passout "pass:${PASSWORD}" \
            -in ${CN}-cert.pem -certfile ${CN}-cert.pem -name ${FQDN}
}

function create_keystore() {
    keytool -importkeystore -srckeystore ${CN}.p12 \
            -srcstorepass "${PASSWORD}" -srcstoretype PKCS12 \
            -srcalias ${FQDN} -deststoretype PKCS12 \
            -destkeystore ${CN}.jks -deststorepass "${PASSWORD}" \
            -destalias ${FQDN}
}

create_self_signed_cert
create_pkcs_file
create_keystore
