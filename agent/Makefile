#!/usr/bin/make -f

build:
	docker build -t markllama/cd-jenkins-agent .

clean:
	-docker rm -f jenkins-agent

run:
	docker run -it --rm \
	--name jenkins-agent \
	-e MASTER_SERVER=${MASTER_SERVER} \
	-e AGENT_NAME=${AGENT_NAME} \
	-e AGENT_SECRET=${AGENT_SECRET} \
	markllama/cd-jenkins-agent
