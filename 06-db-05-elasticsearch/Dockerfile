FROM centos:7

RUN yum install -y wget
RUN groupadd opensearch && useradd opensearch -g opensearch

RUN wget https://artifacts.opensearch.org/releases/bundle/opensearch/2.4.0/opensearch-2.4.0-linux-x64.tar.gz
RUN tar -xf opensearch-2.4.0-linux-x64.tar.gz
RUN rm opensearch-2.4.0-linux-x64.tar.gz

COPY opensearch.yml /opensearch-2.4.0/config/

RUN mkdir /var/lib/opensearch /var/lib/opensearch/data /var/lib/opensearch/log /opensearch-2.4.0/snapshots
RUN chown -R opensearch:opensearch /opensearch-2.4.0
RUN chown -R opensearch:opensearch /var/lib/opensearch

USER opensearch

CMD /opensearch-2.4.0/bin/opensearch

EXPOSE 9200
