yum install -y wget
yum install -y java-11-openjdk-devel 

wget https://artifacts.opensearch.org/releases/bundle/opensearch/2.4.0/opensearch-2.4.0-linux-x64.tar.gz
tar -xf opensearch-2.4.0-linux-x64.tar.gz

groupadd opensearch && useradd opensearch -g opensearch

mkdir /opt/opensearch && mv ./opensearch-2.4.0/* /opt/opensearch && rmdir ./opensearch-2.4.0

chown -R opensearch:opensearch /opt/opensearch

su - opensearch

cp opensearch.yml /opt/opensearch/config/

/opt/opensearch/bin/opensearch
