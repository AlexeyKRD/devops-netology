# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:

- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch

> [Dockerfile](./Dockerfile)  
> `docker build -t opensearch:latest .`

- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий

> `docker tag opensearch:latest alexeykrd/opensearch:latest`  
> `docker push alexeykrd/opensearch:latest`

- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

> `docker run -d -p 9200:9200 -p 9600:9600 opensearch`  
> `vagrant@serv:~$ curl http://localhost:9200`

Требования к `elasticsearch.yml`:

- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

> [elasticsearch.yml](./opensearch.yml)

В ответе приведите:

- текст Dockerfile манифеста

> ```Docker
> FROM centos:7
> 
> RUN yum install -y wget
> RUN groupadd opensearch && useradd opensearch -g opensearch
> 
> RUN wget https://artifacts.opensearch.org/releases/bundle/opensearch/2.4.0/opensearch-2.4.0-linux-x64.tar.gz
> RUN tar -xf opensearch-2.4.0-linux-x64.tar.gz
> RUN rm opensearch-2.4.0-linux-x64.tar.gz
> 
> COPY opensearch.yml /opensearch-2.4.0/config/
> 
> RUN chown -R opensearch:opensearch /opensearch-2.4.0
> RUN mkdir /var/lib/opensearch /var/lib/opensearch/data /var/lib/opensearch/log
> RUN chown -R opensearch:opensearch /var/lib/opensearch
> 
> USER opensearch
> 
> CMD /opensearch-2.4.0/bin/opensearch
> 
> EXPOSE 9200
> ```

- ссылку на образ в репозитории dockerhub

> образ здесь [alexeykrd/opensearch](https://hub.docker.com/r/alexeykrd/opensearch/tags)

- ответ `elasticsearch` на запрос пути `/` в json виде

> ```json
> vagrant@serv:~$ curl http://localhost:9200
> {
>   "name" : "netology_test",
>   "cluster_name" : "netology",
>   "cluster_uuid" : "s5SPuF5ZQTqC_hvw7jNMmg",
>   "version" : {
>     "distribution" : "opensearch",
>     "number" : "2.4.0",
>     "build_type" : "tar",
>     "build_hash" : "744ca260b892d119be8164f48d92b8810bd7801c",
>     "build_date" : "2022-11-15T04:42:29.671309257Z",
>     "build_snapshot" : false,
>     "lucene_version" : "9.4.1",
>     "minimum_wire_compatibility_version" : "7.10.0",
>     "minimum_index_compatibility_version" : "7.0.0"
>   },
>   "tagline" : "The OpenSearch Project: https://opensearch.org/"
> }
> ```

Подсказки:

- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

> использовал эту [документацию](https://opensearch.org/docs/1.0/opensearch/rest-api/create-index/) и [статью](https://www.qunsul.com/posts/opensearch-tutorial.html)
>
> ```shell
> vagrant@serv:~/65$ curl -X PUT http://localhost:9200/ind-1?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true,
>   "index" : "ind-1"
> }
> vagrant@serv:~/65$ curl -X PUT http://localhost:9200/ind-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 2, "number_of_replicas": 1 }}}'
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true,
>   "index" : "ind-2"
> }
> vagrant@serv:~/65$ curl -X PUT http://localhost:9200/ind-3?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 4, "number_of_replicas": 2 }}}'
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true,
>   "index" : "ind-3"
> }
>```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

> ```bash
> vagrant@serv:~$ curl http://localhost:9200/_cat/indices
> green  open ind-1 MmfKitl7RUieA-lk8n45Nw 1 0 0 0 208b 208b
> yellow open ind-3 UpIEpAeFTR-upBGzrymIhg 4 2 0 0 832b 832b
> yellow open ind-2 FWrJjdx1SNSUJHmF2pRGng 2 1 0 0 416b 416b
> ```
>
> либо по каждому `curl http://localhost:9200/_cluster/health/ind-1?pretty`

Получите состояние кластера `elasticsearch`, используя API.

> ```shell
> vagrant@serv:~$ curl http://localhost:9200/_cluster/health?pretty
> {
>   "cluster_name" : "netology",
>   "status" : "yellow",
>   "timed_out" : false,
>   "number_of_nodes" : 1,
>   "number_of_data_nodes" : 1,
>   "discovered_master" : true,
>   "discovered_cluster_manager" : true,
>   "active_primary_shards" : 7,
>   "active_shards" : 7,
>   "relocating_shards" : 0,
>   "initializing_shards" : 0,
>   "unassigned_shards" : 10,
>   "delayed_unassigned_shards" : 0,
>   "number_of_pending_tasks" : 0,
>   "number_of_in_flight_fetch" : 0,
>   "task_max_waiting_in_queue_millis" : 0,
>   "active_shards_percent_as_number" : 41.17647058823529
> }
> ```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

> мы когда создавали индексы указывали кол-во реплик, а по факту та их нет. Поэтому "status" : "yellow".  
> ведь у первого индекса реплик 0 и статус green.  

Удалите все индексы.

> ```shell
> vagrant@serv:~$ curl -X DELETE http://localhost:9200/ind-1?pretty
> {
>   "acknowledged" : true
> }
> vagrant@serv:~$ curl -X DELETE http://localhost:9200/ind-2?pretty
> {
>   "acknowledged" : true
> }
> vagrant@serv:~$ curl -X DELETE http://localhost:9200/ind-3?pretty
> {
>   "acknowledged" : true
> }
> ```

**Важно**
При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:

- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

> добавил в `Dockerfile` создание папки `/opensearch-2.4.0/snapshots`  
> добавил в opensearch.yml `path.repo: /opensearch-2.4.0/snapshots`  
> и пересобрал образ  

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

> ```shell
> vagrant@serv:~/65$ curl -X POST http://localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/opensearch-2.4.0/snapshots" }}'
> {
>   "acknowledged" : true
> }
> ```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

> ```shell
> vagrant@serv:~/65$ curl -X PUT http://localhost:9200/test?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true,
>   "index" : "test"
> }
> vagrant@serv:~/65$ curl http://localhost:9200/_cat/indices?v
> health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
> green  open   test  GPU1Jvo5QzKq-4bQ4kASiQ   1   0          0            0       208b           208b
> ```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) состояния кластера `elasticsearch`.

> ```shell
> vagrant@serv:~/65$ curl -X PUT 'http://localhost:9200/_snapshot/netology_backup/backup01?> wait_for_completion=true&pretty'
> {
>   "snapshot" : {
>     "snapshot" : "backup01",
>     "uuid" : "BGx-2GijRTOu_dXvBuv9ww",
>     "version_id" : 136257827,
>     "version" : "2.4.0",
>     "indices" : [
>       "test"
>     ],
>     "data_streams" : [ ],
>     "include_global_state" : true,
>     "state" : "SUCCESS",
>     "start_time" : "2022-12-11T11:57:04.215Z",
>     "start_time_in_millis" : 1670759824215,
>     "end_time" : "2022-12-11T11:57:04.417Z",
>     "end_time_in_millis" : 1670759824417,
>     "duration_in_millis" : 202,
>     "failures" : [ ],
>     "shards" : {
>       "total" : 1,
>       "failed" : 0,
>       "successful" : 1
>     }
>   }
> }
> ```

**Приведите в ответе** список файлов в директории со `snapshot`ами.

> ```shell
> vagrant@serv:~/65$ docker exec -ti opensearch ls -la /opensearch-2.4.0/snapshots
> total 32
> drwxr-xr-x 1 opensearch opensearch 4096 Dec 11 11:57 .
> drwxr-xr-x 1 opensearch opensearch 4096 Dec 10 14:34 ..
> -rw-r--r-- 1 opensearch opensearch  409 Dec 11 11:57 index-0
> -rw-r--r-- 1 opensearch opensearch    8 Dec 11 11:57 index.latest
> drwxr-xr-x 3 opensearch opensearch 4096 Dec 11 11:57 indices
> -rw-r--r-- 1 opensearch opensearch  370 Dec 11 11:57 meta-BGx-2GijRTOu_dXvBuv9ww.dat
> -rw-r--r-- 1 opensearch opensearch  265 Dec 11 11:57 snap-BGx-2GijRTOu_dXvBuv9ww.dat
> ```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

> ```shell
> vagrant@serv:~/65$ curl -X DELETE http://localhost:9200/test?pretty
> {
>   "acknowledged" : true
> }
> vagrant@serv:~/65$ curl -X PUT http://localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
> {
>   "acknowledged" : true,
>   "shards_acknowledged" : true,
>   "index" : "test-2"
> }
> vagrant@serv:~/65$ curl http://localhost:9200/_cat/indices?v
> health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
> green  open   test-2 Z7aTpMMjRg68R949fPV_SA   1   0          0            0       208b           208b
> ```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее.

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

> ```shell
> vagrant@serv:~/65$ curl -X POST http://localhost:9200/_snapshot/netology_backup/backup01/_restore?pretty
> {
>   "accepted" : true
> }
> vagrant@serv:~/65$ curl http://localhost:9200/_cat/indices?v
> health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
> green  open   test-2 Z7aTpMMjRg68R949fPV_SA   1   0          0            0       208b           208b
> green  open   test   Ax2xGCjgTt-KMvTEy7qNqw   1   0          0            0       208b           208b
> ```

Подсказки:

- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`
