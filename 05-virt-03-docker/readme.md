# Домашнее задание к занятию "3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
> https://hub.docker.com/repository/docker/alexeykrd/netolgy_dz_531  
> либо `docker pull alexeykrd/netolgy_dz_531:v1`
## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?" Детально опишите и обоснуйте свой выбор.
Сценарий:
> - Высоконагруженное монолитное java веб-приложение: Скорей всего подойдет физический сервер, необходимо по максимуму ресурсов) docker думаю не для монолита. 
> - Nodejs веб-приложение: Docker в помощь так сказать)  `docker pull node` из [описания](https://hub.docker.com/_/node): "Node.js-это программная платформа для масштабируемых серверных и сетевых приложений."  
> - Мобильное приложение c версиями для Android и iOS: скорей всего зависит от приложения, думаю можно использовать docker, либо ВМ.     
> - Шина данных на базе Apache Kafka: так как это масштабируемая система, выберу ВМ.   
> - Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana: думаю подойдет ВМ, хотя docker тоже наверно возможно, нашел на hub'e: [elasticsearch](https://hub.docker.com/_/elasticsearch), [kibana](https://hub.docker.com/_/kibana), [logstash](https://hub.docker.com/_/logstash) 
> - Мониторинг-стек на базе Prometheus и Grafana: на hub'e также есть images Prometheus и Grafana, docker вполне подойдет. 
> - MongoDB, как основное хранилище данных для java-приложения: как основное хранилище наверено лучше будет физический сервер, хотя наверно можо использоать все 3 вариата.  
> - Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry: физический сервер либо ВМ.  

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.
> ```
> vagrant@serv:~$ docker images
> REPOSITORY                 TAG       IMAGE ID       CREATED         SIZE
> alexeykrd/netolgy_dz_531   v1        6db2e8181df2   3 days ago      196MB
> nginx                      latest    76c69feac34e   2 weeks ago     142MB
> debian                     latest    d8cacd17cfdc   2 weeks ago     124MB
> centos                     latest    5d0da3dc9764   13 months ago   231MB
> 
> vagrant@serv:~$ docker run -it -d -v ~/data:/data debian
> 346922c81e63885a8f4969a34091f7fd69eef23013192fa986f98cf39d012dfb
> 
> vagrant@serv:~$ docker run -it -d -v ~/data:/data centos
> fd6ffaefbe9d83b54b422d9b93516169b0e28046e3bdefadebdc88551e054539
> 
> vagrant@serv:~$ docker ps
> CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS              PORTS                               NAMES
> fd6ffaefbe9d   centos         "/bin/bash"              52 seconds ago       Up 51 seconds                                           hungry_einstein
> 346922c81e63   debian         "bash"                   About a minute ago   Up About a minute                                       wonderful_villani
> ce86c23c21b0   6db2e8181df2   "/docker-entrypoint.…"   3 hours ago          Up 3 hours          0.0.0.0:66->80/tcp, :::66->80/tcp   gifted_booth
> 
> vagrant@serv:~$ docker exec -it hungry_einstein /bin/bash
> [root@fd6ffaefbe9d /]# cat /etc/os-release > /data/centos.txt
> [root@fd6ffaefbe9d /]# ls -la /data/
> total 12
> drwxrwxr-x 2 1000 1000 4096 Nov  8 12:44 .
> drwxr-xr-x 1 root root 4096 Nov  8 10:24 ..
> -rw-r--r-- 1 root root  333 Nov  8 12:44 centos.txt
> 
> vagrant@serv:~/data$ cat /etc/os-release > ~/data/ubunto.txt
> vagrant@serv:~$ ls -la ~/data
> total 16
> drwxrwxr-x  2 vagrant vagrant 4096 Nov  8 12:50 .
> drwxr-xr-x 14 vagrant vagrant 4096 Nov  8 10:17 ..
> -rw-r--r--  1 root    root     333 Nov  8 12:44 centos.txt
> -rw-rw-r--  1 vagrant vagrant  382 Nov  8 12:50 ubunto.txt
> 
> vagrant@serv:~$ docker exec wonderful_villani ls -la /data
> total 16
> drwxrwxr-x 2 1000 1000 4096 Nov  8 12:50 .
> drwxr-xr-x 1 root root 4096 Nov  8 10:24 ..
> -rw-r--r-- 1 root root  333 Nov  8 12:44 centos.txt
> -rw-rw-r-- 1 1000 1000  382 Nov  8 12:50 ubunto.txt
> ```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
> https://hub.docker.com/repository/docker/alexeykrd/netolgy_dz_534