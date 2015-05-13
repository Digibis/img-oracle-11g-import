
TAG=$(shell basename $$(pwd))

DOCKER:=docker

HOST=$(shell boot2docker ip)


# impdp system/oracle directory=datadir dumpfile=frevvo_resources_080515.dmp full=y;
PORT_MAP=-p 49160:22 -p 49161:1521 -p 49162:8080 -v $(shell pwd)/tmp:/dump

.PHONY: build flatten run start shell clean-containers clean-images

build:
	${DOCKER} build -t=${TAG} .

flatten:
	ID=$$(${DOCKER} run -d ${TAG} /bin/bash) \
	&& ${DOCKER} export $$ID \
	| ${DOCKER} import - ${TAG}

run:
	docker run -i -t ${PORT_MAP} ${TAG}

ssh:
	@echo "**********************************************************************"
	@echo "** User     : root"
	@echo "** Password : admin"
	@echo "**"
	@echo "** >> In case of connection refused, try again in a few seconds ... <<"
	@echo "**"
	@echo "**********************************************************************"
	ssh root@${HOST} -p 49160

start:
	docker run -d ${PORT_MAP} ${TAG}

shell:
	${DOCKER} run -t --entrypoint /bin/bash -i ${PORT_MAP} --rm ${TAG}

.PHONY: web
web:
	open http://${HOST}:49162/apex


clean-containers:
	${DOCKER} ps -a -q | xargs -I % docker rm %

clean-images: clean-containers
	${DOCKER} images | grep "<none>" | awk '{ print $$3 }' | xargs -I {} docker rmi {}


