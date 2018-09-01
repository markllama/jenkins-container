#!/usr/bin/make -f

build:
	docker build -t markllama/cd-jenkins-agent .

clean:
	-docker rm -f jenkins-agent

run:
	docker run -it --rm \
	--name jenkins-agent \
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
	markllama/cd-jenkins-agent

rund:
	docker run -d \
	--name jenkins-agent \
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
	markllama/cd-jenkins-agent
