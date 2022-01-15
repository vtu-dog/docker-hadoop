#!/bin/bash

STREAM_JAR=$(find $HADOOP_HOME/share/hadoop/tools/lib/ -iname "hadoop-streaming-*.jar")
$HADOOP_HOME/bin/hadoop jar $STREAM_JAR -input /input -output /output -mapper "$MAPPER" -reducer "$REDUCER"