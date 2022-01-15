FROM hadoop-base

COPY project/MapReduce/build/libs/MapReduce.jar /opt/hadoop/applications/MapReduce.jar

ENV JAR_FILEPATH="/opt/hadoop/applications/MapReduce.jar"
ARG CLASS_TO_RUN
ARG PARAMS

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
