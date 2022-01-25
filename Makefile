DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
CLASS = mapreduce.MapReduce
PARAMS = /input /output

.PHONY: submit stream stream-python clean

build:
	docker build -t hadoop-base ./base

down:
	docker compose down -v --remove-orphans

1dn: build
	docker compose up -d

3dn: build
	docker build -t hadoop-base ./base
	docker compose -f docker-compose-3dn.yml up -d

pack:
	docker run --rm \
		-v ${PWD}/submit/project:/home/gradle \
		-v gradle_cache:/home/gradle/.gradle \
		gradle:7-jdk11 gradle jar --no-daemon --info

submit:
	docker build -t hadoop-submit ./submit
	docker build -t hadoop-tmp .
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -mkdir -p /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -copyFromLocal -f /input/ /
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} -e CLASS_TO_RUN=${CLASS} -e PARAMS="${PARAMS}" hadoop-submit

stream:
ifndef MAPPER
	$(error MAPPER is undefined)
endif
ifndef REDUCER
	$(error REDUCER is undefined)
endif
	docker build -t hadoop-stream ./stream
	docker build -t hadoop-tmp .
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -mkdir -p /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -copyFromLocal -f /input/ /
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} -e MAPPER="${MAPPER}" -e REDUCER="${REDUCER}" hadoop-stream

stream-python:
	docker build -t hadoop-stream ./stream
	docker build -t hadoop-tmp .
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -mkdir -p /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -copyFromLocal -f /input/ /
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} -e USE_FILE=true hadoop-stream

clean:
	-docker rm -fv hadoop-tmp
	-docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -rm -r /input
	-docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -rm -r /output

nuke: down
	docker system prune -af
	docker volume rm $$(docker volume ls -q)
