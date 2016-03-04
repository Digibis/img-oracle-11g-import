
TAG=$(shell basename $$(pwd))

DOCKER:=docker

HOST=localhost

EXT_PORT_SHH=2221
EXT_PORT_TOMCAT=8081
EXT_PORT_ORACLE=1521


PORT_MAP=-p ${EXT_PORT_SHH}:22 -p ${EXT_PORT_ORACLE}:1521 -p ${EXT_PORT_TOMCAT}:8080 -v $(shell pwd)/tmp:/dump

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
	ssh root@${HOST} -p ${EXT_PORT_SHH}

start:
	docker run -d ${PORT_MAP} ${TAG}

shell:
	${DOCKER} run -t --entrypoint /bin/bash -i ${PORT_MAP} --rm ${TAG}

.PHONY: web
web:
	open http://${HOST}:${EXT_PORT_TOMCAT}/apex


clean-containers:
	${DOCKER} ps -a -q | xargs -I % docker rm %

clean-images: clean-containers
	${DOCKER} images | grep "<none>" | awk '{ print $$3 }' | xargs -I {} docker rmi {}


