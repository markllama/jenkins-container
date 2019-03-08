#!/usr/bin/make -f
IMAGE_NAME="jenkins-agent-cloud-cli"

build:
	docker build -t quay.io/mlamouri/${IMAGE_NAME} .

clean:
	-docker rm -f ${IMAGE_NAME}

run:
	docker run -it --rm \
	--name ${IMAGE_NAME} \
	--volume ~/.ssh:/jenkins/agent/.ssh:z \
	-e MASTER_SERVER=${MASTER_SERVER} \
	-e AGENT_NAME=${AGENT_NAME} \
	-e AGENT_SECRET=${AGENT_SECRET} \
	-e JENKINS_UID=`id -u` \
	-e JENKINS_GID=`id -g` \
  -e KRB5_REALM=$(KRB5_REALM) \
  -e KRB5_KDC=$(KRB5_KDC) \
  -e KRB5_ADMIN_SERVER=$(KRB5_ADMIN_SERVER) \
  -e GIT_USER="${GIT_USER}" \
  -e GIT_EMAIL=${GIT_EMAIL} \
	quay.io/mlamouri/${IMAGE_NAME}

rund:
	docker run -d \
	--name ${IMAGE_NAME} \
	--volume ~/.ssh:/jenkins/agent/.ssh:z \
	-e MASTER_SERVER=${MASTER_SERVER} \
	-e AGENT_NAME=${AGENT_NAME} \
	-e AGENT_SECRET=${AGENT_SECRET} \
	-e JENKINS_UID=`id -u` \
	-e JENKINS_GID=`id -g` \
  -e KRB5_REALM=$(KRB5_REALM) \
  -e KRB5_KDC=$(KRB5_KDC) \
  -e KRB5_ADMIN_SERVER=$(KRB5_ADMIN_SERVER) \
  -e GIT_USER="${GIT_USER}" \
  -e GIT_EMAIL=${GIT_EMAIL} \
	quay.io/mlamouri/${IMAGE_NAME}
