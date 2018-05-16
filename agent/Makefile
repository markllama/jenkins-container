#!/usr/bin/make -f

build:
	docker build -t markllama/cd-jenkins-agent .

clean:
	-docker rm -f jenkins-agent

run:
	docker run -it --rm \
	--name jenkins-agent \
	markllama/cd-jenkins-agent
