FROM docker.elastic.co/elasticsearch/elasticsearch:5.6.3

MAINTAINER Lumis

RUN set -x && \
	sed -i -e 's/rootLogger.level = info/rootLogger.level = warn/' config/log4j2.properties && \
	bin/elasticsearch-plugin remove x-pack && \
	rm -Rf config/x-pack && \
	bin/elasticsearch-plugin remove ingest-geoip && \
	rm -Rf config/ingest-geoip && \
	bin/elasticsearch-plugin remove ingest-user-agent && \
	bin/elasticsearch-plugin install analysis-icu && \
	sed -i -e 's/docker-cluster/elasticsearch/' config/elasticsearch.yml && \
	echo "action.auto_create_index: -*" >> config/elasticsearch.yml
