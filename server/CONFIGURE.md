# Volumes

* `jenkins.jks`
  The Java Keystore for an SSL certificate for session encryption

To get SELinux permissions set properly, use the `z` option on the volume spec
---
docker run ... --volume -volume $(pwd)/hp-blade15.jks:/jenkins.jks:z ...
---


# Variables

* `KEYSTORE_PASSWORD`
  The password to access the Java Keystore and establish SSL communications

# CLI tool

* https://wiki.jenkins.io/display/JENKINS/Jenkins+CLI

