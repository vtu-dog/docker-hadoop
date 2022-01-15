FROM hadoop-base

ENV MAPPER_FILEPATH="/opt/hadoop/applications/mapper.py"
ENV REDUCER_FILEPATH="/opt/hadoop/applications/reducer.py"

COPY mapper.py $MAPPER_FILEPATH
COPY reducer.py $REDUCER_FILEPATH

ARG MAPPER
ARG REDUCER
ARG USE_FILE=false

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
