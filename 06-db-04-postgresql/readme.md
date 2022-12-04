# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

> создаем `./docker-compose.yml`  
> запускаем контейнер `docker-compose up -d`  

Подключитесь к БД PostgreSQL используя `psql`.

> `psql -U sa`

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД

> `\l[+] [PATTERN]` - list databases

- подключения к БД

> `\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}` - connect to new database (currently "sa")

- вывода списка таблиц

> `\dt[S+] [PATTERN]` - list tables

- вывода описания содержимого таблиц

 > `\d[S+] NAME` - describe table, view, sequence, or index

- выхода из psql

> `\q` - quit psql`

## Задача 2

Используя `psql` создайте БД `test_database`.

> `create database test_database;`

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

> `psql -U sa test_database < /var/lib/postgresql/backup/test_dump.sql`

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

> ```code
> b0fdf1a1f7e6:/# psql -U sa test_database
> psql (13.9)
> Type "help" for help.
> test_database=# ANALYZE VERBOSE orders;
> INFO:  analyzing "public.orders"
> INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
> ANALYZE
> ```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

> ```code
> test_database=# select tablename, attname, avg_width from pg_stats where tablename = 'orders';
>  tablename | attname | avg_width
> -----------+---------+-----------
>  orders    | id      |         4
>  orders    | title   |        16
>  orders    | price   |         4
> (3 rows)
> ```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.  
[статья](https://itnan.ru/post.php?c=1&p=309330) в помошь  

> ```code
> begin;
>   create table orders_new ( like orders including all );  
>   create table orders_1 (check (price > 499)) inherits (orders_new);
>   create table orders_2 (check (price <= 499)) inherits (orders_new);
>   create rule insert_orders_1 as on insert to orders_new where (price > 499) do instead insert into orders_1 values (new.*);
>   create rule insert_orders_2 as on insert to orders_new where (price <= 499) do instead insert into orders_2 values (new.*);
>   insert into orders_new select * from orders;
> commit;
> ```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

> почему бы и нет) ничего не мешало это зделать в момент создания таблицы.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

> `pg_dump -U sa -W test_database > /var/lib/postgresql/backup/backup.dump`

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

> добавить в конец файла backup.dump для необходимых таблиц `ALTER TABLE orders ADD CONSTRAINT orders_title_unique UNIQUE (title);`  
> например так)) `echo "ALTER TABLE orders ADD CONSTRAINT orders_title_unique UNIQUE (title);" >> /var/lib/postgresql/backup/backup.dump`
