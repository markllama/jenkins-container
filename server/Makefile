#!make -f

KEYSTORE_FILE = $(PWD)/keystore.jks
KEYSTORE_PASSWORD = badpassword
CONFIG_SCM_REPO = git@github.com:markllama/jenkins-config.git
CONFIG_SCM_USER = markllama
CONFIG_SCM_KEYFILE = $(HOME)/jenkins-agent-keys/id_rsa

build:
	docker build -t markllama/cd-jenkins .

clean:
	-docker rm -f jenkins

run: volumes
	docker run -it --rm \
	--name jenkins \
	--net=host \
	--volume $(KEYSTORE_FILE):/jenkins/keystore.jks:z \
	--volume `pwd`/backups:/jenkins/backups:z \
	--volume jenkins-secrets:/jenkins/secrets \
	--volume jenkins-builds:/jenkins/var/builds \
	--volume jenkins-workspaces:/jenkins/var/workspaces \
	--volume $(CONFIG_SCM_KEYFILE):/var/lib/jenkins/.ssh/id_rsa:z \
	-e HTTPS_KEYSTORE_PASSWORD=$(KEYSTORE_PASSWORD) \
	-e JENKINS_UID=`id -u` \
	-e JENKINS_GID=`id -g` \
	-e SERVER_FQDN=${SERVER_FQDN} \
	-e ADMIN_EMAIL=${ADMIN_EMAIL} \
  -e CONFIG_SCM_REPO=$(CONFIG_SCM_REPO) \
  -e CONFIG_SCM_USER=$(CONFIG_SCM_USER) \
	markllama/cd-jenkins

rund: volumes
	docker run -d --rm \
	--name jenkins \
	--net=host \
	--volume $(KEYSTORE_FILE):/jenkins/keystore.jks:z \
	--volume `pwd`/backups:/jenkins/backups:z \
	--volume jenkins-secrets:/jenkins/secrets \
	--volume jenkins-builds:/jenkins/var/builds \
	--volume `pwd`/workspaces:/jenkins/var/workspaces:z \
	--volume $(CONFIG_SCM_KEYFILE):/var/lib/jenkins/.ssh/id_rsa:z \
	-e HTTPS_KEYSTORE_PASSWORD=$(KEYSTORE_PASSWORD) \
	-e JENKINS_UID=`id -u` \
	-e JENKINS_GID=`id -g` \
  -e SERVER_FQDN=${SERVER_FQDN} \
  -e ADMIN_EMAIL=${ADMIN_EMAIL} \
  -e CONFIG_SCM_REPO=$(CONFIG_SCM_REPO) \
  -e CONFIG_SCM_USER=$(CONFIG_SCM_USER) \
	markllama/cd-jenkins

join:
	docker exec -it jenkins /bin/bash

volumes:
	docker volume create jenkins-backups
	docker volume create jenkins-builds
	docker volume create jenkins-secrets 
	docker volume create jenkins-workspaces

clean-volumes: clean
	docker volume rm jenkins-backups
	docker volume rm jenkins-builds
	docker volume rm jenkins-secrets
	docker volume rm jenkins-workspaces
