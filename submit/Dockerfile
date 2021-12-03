FROM hadoop-base

COPY project/MapReduce/build/libs/MapReduce.jar /opt/hadoop/applications/MapReduce.jar

ENV JAR_FILEPATH="/opt/hadoop/applications/MapReduce.jar"
ENV CLASS_TO_RUN="MapReduce"
ENV PARAMS="/input /output"

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
