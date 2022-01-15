DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
CLASS = MapReduce
PARAMS = "/input /output"

.PHONY: submit clean

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
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} -e CLASS_TO_RUN=${CLASS} -e PARAMS='${PARAMS}' hadoop-submit

clean:
	docker rm -fv hadoop-tmp
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -rm -r /output
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -rm -r /input

nuke: down
	docker system prune -af
	docker volume rm $$(docker volume ls -q)
