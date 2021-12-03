DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
base_version := --build-arg HADOOP_BASE_VERSION=$(current_branch)
build:
	docker build -t hadoop-base:$(current_branch) ./base
	docker build -t hadoop-namenode:$(current_branch) $(base_version) ./namenode
	docker build -t hadoop-datanode:$(current_branch) $(base_version) ./datanode
	docker build -t hadoop-resourcemanager:$(current_branch) $(base_version) ./resourcemanager
	docker build -t hadoop-nodemanager:$(current_branch) $(base_version) ./nodemanager
	docker build -t hadoop-historyserver:$(current_branch) $(base_version) ./historyserver
	docker build -t hadoop-submit:$(current_branch) $(base_version) ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-base:$(current_branch) hdfs dfs -rm -r /input
