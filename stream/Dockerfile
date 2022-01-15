FROM hadoop-base

ARG MAPPER
ARG REDUCER

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
