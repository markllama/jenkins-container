# Jenkins Container

This repo defines a Jenkins master server in a container image. The base is
RHEL or CentOS.

The goal is to create an image that is ready to restore a
configuration from a backup and take over as the master Jenkins
server for a build "cluster". It will enforce SSL with a provided
cert/key set.


## Traffic Encryption - SSL

When starting the container, the user maps a Java Key Store to
`/jenkins/keystore.jks` and provides the password using the
*KEYSTORE_PASSWORD* environment variable. The Jenkins server uses the
keystore to establish SSL communication using the certificate inside.

## User Authentication



## Auto-Configuration - restore backup
