DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env

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

submit:
	docker build -t hadoop-submit ./submit
	docker build -t hadoop-tmp .
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -mkdir -p /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -copyFromLocal -f /input/ /
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-submit

clean:
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -rm -r /output
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-tmp hdfs dfs -rm -r /input

nuke: down
	docker system prune -af
	docker volume rm $(docker volume ls -q)
