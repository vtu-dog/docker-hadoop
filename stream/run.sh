#!/bin/bash

STREAM_JAR=$(find $HADOOP_HOME/share/hadoop/tools/lib/ -iname "hadoop-streaming-*.jar")

if [ "$USE_FILE" = true ]; then
    $HADOOP_HOME/bin/hadoop jar $STREAM_JAR -input /input -output /output \
        -file $MAPPER_FILEPATH  -mapper $MAPPER_FILEPATH \
        -file $REDUCER_FILEPATH -reducer $REDUCER_FILEPATH
else
    $HADOOP_HOME/bin/hadoop jar $STREAM_JAR -input /input -output /output -mapper "$MAPPER" -reducer "$REDUCER"
fi
