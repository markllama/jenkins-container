#!/usr/bin/make -f

REPO_NAME=quay.io
REPO_USER=mlamouri
IMAGE_NAME=$(REPO_NAME)/$(REPO_USER)/art-jenkins-agent

DOCKER_GROUP = docker
DOCKER_GID = `grep ${DOCKER_GROUP} /etc/group | cut -d: -f3`

SSH_KEY_DIR = $(HOME)/jenkins-agent-keys

build:
	docker build -t ${IMAGE_NAME} .

clean:
	-docker rm -f ${IMAGE_NAME}

run:
	docker run -it --rm \
	--name jenkins-agent \
	--volume ${SSH_KEY_DIR}:/jenkins/agent/.ssh:z \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	-e MASTER_SERVER=${MASTER_SERVER} \
	-e AGENT_NAME=${AGENT_NAME} \
	-e AGENT_SECRET=${AGENT_SECRET} \
	-e JENKINS_UID=`id -u` \
	-e JENKINS_GID=`id -g` \
  -e DOCKER_GID=${DOCKER_GID} \
  -e KRB5_REALM=$(KRB5_REALM) \
  -e KRB5_KDC=$(KRB5_KDC) \
  -e KRB5_ADMIN_SERVER=$(KRB5_ADMIN_SERVER) \
  -e GIT_USER="${GIT_USER}" \
  -e GIT_EMAIL=${GIT_EMAIL} \
	${IMAGE_NAME}

rund:
	docker run -d \
	--name jenkins-agent \
	--volume ${SSH_KEY_DIR}:/jenkins/agent/.ssh:z \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	-e MASTER_SERVER=${MASTER_SERVER} \
	-e AGENT_NAME=${AGENT_NAME} \
	-e AGENT_SECRET=${AGENT_SECRET} \
	-e JENKINS_UID=`id -u` \
	-e JENKINS_GID=`id -g` \
  -e DOCKER_GID=${DOCKER_GID} \
  -e KRB5_REALM=$(KRB5_REALM) \
  -e KRB5_KDC=$(KRB5_KDC) \
  -e KRB5_ADMIN_SERVER=$(KRB5_ADMIN_SERVER) \
  -e GIT_USER="${GIT_USER}" \
  -e GIT_EMAIL=${GIT_EMAIL} \
	${IMAGE_NAME}
