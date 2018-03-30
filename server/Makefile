#!make -f

KEYSTORE_FILE = $(PWD)/keystore.jks
KEYSTORE_PASSWORD = badpassword

build:
	docker build -t markllama/cd-jenkins .

clean:
	docker rm -f jenkins

run:
	docker run -it --rm \
	--name jenkins \
	--net=host \
	--volume $(KEYSTORE_FILE):/jenkins/keystore.jks:z \
	-e HTTPS_KEYSTORE_PASSWORD=$(KEYSTORE_PASSWORD) \
	-e JENKINS_UID=`id -u` \
	-e JENKINS_GID=`id -g` \
	markllama/cd-jenkins

join:
	docker exec -it jenkins /bin/bash


