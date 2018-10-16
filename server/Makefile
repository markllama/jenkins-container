#!make -f

REPO_NAME=quay.io
REPO_USER=mlamouri
IMAGE_NAME=$(REPO_NAME)/$(REPO_USER)/art-jenkins

KEYSTORE_FILE = $(PWD)/keystore.jks
KEYSTORE_PASSWORD = badpassword
CONFIG_SCM_REPO = git@github.com:markllama/jenkins-config.git
CONFIG_SCM_USER = markllama
SSH_KEY_DIR = $(HOME)/jenkins-agent-keys

build:
	docker build -t $(IMAGE_NAME) .

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
	--volume $(SSH_KEY_DIR):/var/lib/jenkins/.ssh:z \
	-e HTTPS_KEYSTORE_PASSWORD=$(KEYSTORE_PASSWORD) \
	-e JENKINS_UID=`id -u` \
	-e JENKINS_GID=`id -g` \
	-e SERVER_FQDN=${SERVER_FQDN} \
	-e ADMIN_EMAIL=${ADMIN_EMAIL} \
  -e CONFIG_SCM_REPO=$(CONFIG_SCM_REPO) \
  -e CONFIG_SCM_USER=$(CONFIG_SCM_USER) \
  -e KRB5_REALM=$(KRB5_REALM) \
  -e KRB5_KDC=$(KRB5_KDC) \
  -e KRB5_ADMIN_SERVER=$(KRB5_ADMIN_SERVER) \
  -e GIT_USER="${GIT_USER}" \
  -e GIT_EMAIL=${GIT_EMAIL} \
	$(IMAGE_NAME)

rund: volumes
	docker run -d --rm \
	--name jenkins \
	--net=host \
	--volume $(KEYSTORE_FILE):/jenkins/keystore.jks:z \
	--volume `pwd`/backups:/jenkins/backups:z \
	--volume jenkins-secrets:/jenkins/secrets \
	--volume jenkins-builds:/jenkins/var/builds \
	--volume jenkins-workspaces:/jenkins/var/workspaces:z \
	--volume $(SSH_KEY_DIR):/var/lib/jenkins/.ssh:z \
	-e HTTPS_KEYSTORE_PASSWORD=$(KEYSTORE_PASSWORD) \
	-e JENKINS_UID=`id -u` \
	-e JENKINS_GID=`id -g` \
  -e SERVER_FQDN=${SERVER_FQDN} \
  -e ADMIN_EMAIL=${ADMIN_EMAIL} \
  -e CONFIG_SCM_REPO=$(CONFIG_SCM_REPO) \
  -e CONFIG_SCM_USER=$(CONFIG_SCM_USER) \
  -e KRB5_REALM=$(KRB5_REALM) \
  -e KRB5_KDC=$(KRB5_KDC) \
  -e KRB5_ADMIN_SERVER=$(KRB5_ADMIN_SERVER) \
  -e GIT_USER="${GIT_USER}" \
  -e GIT_EMAIL=${GIT_EMAIL} \
  $(IMAGE_NAME)

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
