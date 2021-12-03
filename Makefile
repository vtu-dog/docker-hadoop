DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env

build-single:
	docker build -t hadoop-base ./base
	docker compose up -d

build-multiple:
	docker build -t hadoop-base ./base
	docker compose -f docker-compose-3dn.yml up -d

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base hdfs dfs -mkdir -p /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base hdfs dfs -copyFromLocal -f /opt/hadoop/README.txt /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base hdfs dfs -cat /output/*

clean:
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base hdfs dfs -rm -r /output
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base hdfs dfs -rm -r /input
