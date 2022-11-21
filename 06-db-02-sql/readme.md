# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

> создаём docker-compose.yaml с содержимы
>
> ```code
> version: "3.9"
>
> services:
>   postgres:
>     image: postgres:12
>     container_name: my_postgres
>     environment:
>       POSTGRES_USER: "sa"
>       POSTGRES_PASSWORD: "sa"
>       PGDATA: "/var/lib/postgresql/data/pgdata"
>     volumes:
>       - ./data:/var/lib/postgresql/data
>       - ./backup:/var/lib/postgresql/backup
> ```
>
> запускаем контейнер `docker-compose up -d`  
> зайдем на контейнер и проверим PostgreSQL
>
> ```code
> vagrant@serv:~/56$ docker exec -it my_postgres bash
> root@e3528a6e7b14:/# postgres --version
> postgres (PostgreSQL) 12.13 (Debian 12.13-1.pgdg110+1)
> ```  

## Задача 2

В БД из задачи 1:

- создайте пользователя test-admin-user и БД test_db

> ```CODE
> sa=# CREATE USER "test-admin-user";
> CREATE ROLE
> sa=# CREATE DATABASE "test_db";
> CREATE DATABASE
> ```

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)

> подключаемся к базе test_db и создаем таблицы `\c test_db`
>
> ```code
> test_db=# CREATE TABLE orders (id SERIAL PRIMARY KEY, name TEXT, price INT);
> CREATE TABLE
> test_db=# CREATE TABLE clients (id SERIAL PRIMARY KEY, lname TEXT, country TEXT, ord INT, FOREIGN KEY (ord) REFERENCES orders (id));
> CREATE TABLE
> ```

- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db

> ```code
> test_db=# GRANT ALL ON orders, clients TO "test-admin-user";
> GRANT
> 
> ```

- создайте пользователя test-simple-user  

> ```code
> sa=# CREATE USER "test-simple-user";
> CREATE ROLE
> ```

- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

> ```code
> test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-simple-user";
> GRANT
> ```

Таблица orders:

- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:

- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:

- итоговый список БД после выполнения пунктов выше,

> ```code
> test_db=# \l
>                              List of databases
>   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
> -----------+-------+----------+------------+------------+-------------------
>  postgres  | sa    | UTF8     | en_US.utf8 | en_US.utf8 |
>  sa        | sa    | UTF8     | en_US.utf8 | en_US.utf8 |
>  template0 | sa    | UTF8     | en_US.utf8 | en_US.utf8 | =c/sa            +
>            |       |          |            |            | sa=CTc/sa
>  template1 | sa    | UTF8     | en_US.utf8 | en_US.utf8 | =c/sa            +
>            |       |          |            |            | sa=CTc/sa
>  test_db   | sa    | UTF8     | en_US.utf8 | en_US.utf8 |
> (5 rows)
> ```

- описание таблиц (describe)

> ```code
> test_db=# \d clients
>                             Table "public.clients"
>  Column  |  Type   | Collation | Nullable |               Default
> ---------+---------+-----------+----------+-------------------------------------
>  id      | integer |           | not null | nextval('clients_id_seq'::regclass)
>  lname   | text    |           |          |
>  country | text    |           |          |
>  ord     | integer |           |          |
> Indexes:
>     "clients_pkey" PRIMARY KEY, btree (id)
> Foreign-key constraints:
>     "clients_ord_fkey" FOREIGN KEY (ord) REFERENCES orders(id)
>
> test_db=# \d orders
>                             Table "public.orders"
>  Column |  Type   | Collation | Nullable |              Default
> --------+---------+-----------+----------+------------------------------------
>  id     | integer |           | not null | nextval('orders_id_seq'::regclass)
>  name   | text    |           |          |
>  price  | integer |           |          |
> Indexes:
>     "orders_pkey" PRIMARY KEY, btree (id)
> Referenced by:
>     TABLE "clients" CONSTRAINT "clients_ord_fkey" FOREIGN KEY (ord) REFERENCES orders(id)
> ```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

> ```code
> SELECT * FROM information_schema.table_privileges WHERE table_catalog = 'test_db';
> ```

- список пользователей с правами над таблицами test_db

> ```code
> test_db=# select * from information_schema.table_privileges where table_name='clients' or table_name='orders';
> grantor |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
> ---------+------------------+---------------+--------------+------------+----------------+--------------+----------------
> sa      | sa               | test_db       | public       | orders     | INSERT         | YES          | NO
> sa      | sa               | test_db       | public       | orders     | SELECT         | YES          | YES
> sa      | sa               | test_db       | public       | orders     | UPDATE         | YES          | NO
> sa      | sa               | test_db       | public       | orders     | DELETE         | YES          | NO
> sa      | sa               | test_db       | public       | orders     | TRUNCATE       | YES          | NO
> sa      | sa               | test_db       | public       | orders     | REFERENCES     | YES          | NO
> sa      | sa               | test_db       | public       | orders     | TRIGGER        | YES          | NO
> sa      | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
> sa      | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
> sa      | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
> sa      | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
> sa      | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
> sa      | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
> sa      | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
> sa      | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
> sa      | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
> sa      | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
> sa      | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
> sa      | sa               | test_db       | public       | clients    | INSERT         | YES          | NO
> sa      | sa               | test_db       | public       | clients    | SELECT         | YES          | YES
> sa      | sa               | test_db       | public       | clients    | UPDATE         | YES          | NO
> sa      | sa               | test_db       | public       | clients    | DELETE         | YES          | NO
> sa      | sa               | test_db       | public       | clients    | TRUNCATE       | YES          | NO
> sa      | sa               | test_db       | public       | clients    | REFERENCES     | YES          | NO
> sa      | sa               | test_db       | public       | clients    | TRIGGER        | YES          | NO
> sa      | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
> sa      | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
> sa      | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
> sa      | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
> sa      | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
> sa      | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
> sa      | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
> --More--
> ```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:

- вычислите количество записей для каждой таблицы 
- приведите в ответе:
  - запросы
  - результаты их выполнения.

> ```code
> test_db=# INSERT INTO orders (name, price) VALUES ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
> INSERT 0 5
> test_db=# SELECT COUNT(*) FROM orders;
>  count
> -------
>      5
> (1 row)
>
> test_db=# INSERT INTO clients (lname, country) VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
> INSERT 0 5
> test_db=# SELECT COUNT(*) FROM clients;
>  count
> -------
>      5
> (1 row)
> ```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Подсказк - используйте директиву `UPDATE`.

> ```code
> test_db=# UPDATE clients SET ord=3 WHERE id=1;
> UPDATE 1
> test_db=# UPDATE clients SET ord=4 WHERE id=2;
> UPDATE 1
> test_db=# UPDATE clients SET ord=5 WHERE id=3;
> UPDATE 1
> test_db=# SELECT * FROM clients WHERE ord IS NOT NULL;
>  id |        lname         | country | ord
> ----+----------------------+---------+-----
>   1 | Иванов Иван Иванович | USA     |   3
>   2 | Петров Петр Петрович | Canada  |   4
>   3 | Иоганн Себастьян Бах | Japan   |   5
> (3 rows)
> ```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

> ```code
> test_db=# EXPLAIN SELECT * FROM clients WHERE ord IS NOT NULL;
>                         QUERY PLAN
> -----------------------------------------------------------
>  Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
>    Filter: (ord IS NOT NULL)
> (2 rows)
> ```
>
> EXPLAIN выводит информацию, необходимую для понимания, что же делает ядро при каждом конкретном запросе.  
> Seq Scan — последовательное чтение данных из таблицы, блок за блоком.  
> cost - затратность операции, первое значение (0.00) затраты на получение первой строки, второе (18.10) на получение всех срок.  
> rows — приблизительное количество возвращаемых строк при выполнении операции Seq Scan.  
> width — средний размер одной строки в байтах.  
> 
> Можно получить чуть больше информации (используя ANALYZE) но быть аккуратней ибо запрос будет выполняться реально)) (я про INSERT, DELETE или UPDATE).
>
> ```code
> test_db=# EXPLAIN (ANALYZE) SELECT * FROM clients WHERE ord IS NOT NULL;
>                                              QUERY PLAN
> -----------------------------------------------------------------------------------------------------
>  Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72) (actual time=0.020..0.022 rows=3 loops=1)
>    Filter: (ord IS NOT NULL)
>    Rows Removed by Filter: 2
>  Planning Time: 0.082 ms
>  Execution Time: 0.044 ms
> (5 rows)
> ```
>
> actual time — реальное время в миллисекундах, затраченное для получения первой строки и всех строк соответственно.  
> rows — реальное количество строк, полученных при Seq Scan.  
> loops — сколько раз пришлось выполнить операцию Seq Scan.  
> Total runtime — общее время выполнения запроса.  

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

> вариант 1 (выгружает только одну базу данных, без ролей. "Чтобы сохранить глобальные объекты, относящиеся ко всем базам в кластере, например, роли и табличные пространства, воспользуйтесь программой pg_dumpall."):  
> создаем бекап `docker exec -i my_postgres pg_dump -U sa test_db > backup/test_db_dump.sql`  
> создаем пустую базу `docker exec -i my_postgres psql -U sa -c 'CREATE DATABASE test_db2'`  
> восстанавливаем БД `docker exec -i my_postgres psql -U sa -d test_db2 < ./backup/test_db_dump.sql`  
>
> другой вариант (не нужно создавать БД):  
> создаем бекап `docker exec -i my_postgres2 pg_dumpall -U sa -f ./backup/back_dump_all.sql`  
> восстанавливаем БД `docker exec -i my_postgres2 psql -U postgres -f ./backup/back_dump_all.sql`  
>
> еще вариант с ипользованием `pg_basebackup` ): 