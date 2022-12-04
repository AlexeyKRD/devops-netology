# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с [дополнительными материалами](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

> создаем `./docker-compose.yml`  
>  
> ```Code
> version: '3.1'
>
> services:
>  mysql_db:
>    image: mysql:8
>    container_name: my_sql63
>    restart: always
>    ports:
>      - "3306:3306"
>    environment:
>      MYSQL_ROOT_PASSWORD: sa
>      MYSQL_DATABASE: test_db63
>    volumes:
>      - ./data:/var/lib/mysql/
>      - ./backup:/backup
> ```
>
> запускаем контейнер `docker-compose up -d`  
> и заходим на него `docker exec -it my_sql63 bash`

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-03-mysql/test_data) и восстановитесь из него.

> восстанавливаем БД коммандой:
>
> ```code
> bash-4.4# mysql -u root -p test_db63 < ./backup/test_dump.sql
> Enter password:
> ```

Перейдите в управляющую консоль `mysql` внутри контейнера.

> ```code
> bash-4.4# mysql -p
> Enter password:
> Welcome to the MySQL monitor.  Commands end with ; or \g.
> Your MySQL connection id is 14
> Server version: 8.0.31 MySQL Community Server - GPL
> 
> Copyright (c) 2000, 2022, Oracle and/or its affiliates.
> 
> Oracle is a registered trademark of Oracle Corporation and/or its
> affiliates. Other names may be trademarks of their respective
> owners.
>
> Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
> ```

Используя команду `\h` получите список управляющих команд.

> ```code
> mysql> \h
> 
> For information about MySQL products and services, visit:
>    http://www.mysql.com/
> For developer information, including the MySQL Reference Manual, visit:
>    http://dev.mysql.com/
> To buy MySQL Enterprise support, training, or other products, visit:
>    https://shop.mysql.com/
> 
> List of all MySQL commands:
> Note that all text commands must be first on line and end with ';'
> ?         (\?) Synonym for `help'.
> clear     (\c) Clear the current input statement.
> connect   (\r) Reconnect to the server. Optional arguments are db and host.
> delimiter (\d) Set statement delimiter.
> edit      (\e) Edit command with $EDITOR.
> ego       (\G) Send command to mysql server, display result vertically.
> exit      (\q) Exit mysql. Same as quit.
> go        (\g) Send command to mysql server.
> help      (\h) Display this help.
> nopager   (\n) Disable pager, print to stdout.
> notee     (\t) Don't write into outfile.
> pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
> print     (\p) Print current command.
> prompt    (\R) Change your mysql prompt.
> quit      (\q) Quit mysql.
> rehash    (\#) Rebuild completion hash.
> source    (\.) Execute an SQL script file. Takes a file name as an argument.
> status    (\s) Get status information from the server.
> system    (\!) Execute a system shell command.
> tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
> use       (\u) Use another database. Takes database name as argument.
> charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
> warnings  (\W) Show warnings after every statement.
> nowarning (\w) Don't show warnings after every statement.
> resetconnection(\x) Clean session context.
> query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
> ssl_session_data_print Serializes the current SSL session data to stdout or file
>
> For server side help, type 'help contents'
> ```

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

> ```code
> mysql> \s
> --------------
> mysql  Ver 8.0.31 for Linux on x86_64 (MySQL Community Server - GPL)
>
> Connection id:          14
> Current database:
> Current user:           root@localhost
> SSL:                    Not in use
> Current pager:          stdout
> Using outfile:          ''
> Using delimiter:        ;
> Server version:         8.0.31 MySQL Community Server - GPL
> Protocol version:       10
> Connection:             Localhost via UNIX socket
> Server characterset:    utf8mb4
> Db     characterset:    utf8mb4
> Client characterset:    latin1
> Conn.  characterset:    latin1
> UNIX socket:            /var/run/mysqld/mysqld.sock
> Binary data as:         Hexadecimal
> Uptime:                 23 min 34 sec
> 
> Threads: 2  Questions: 90  Slow queries: 0  Opens: 187  Flush tables: 3  Open tables: 104  Queries per second avg: 0.063
> --------------
> ```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

> ```code
> mysql> show databases;
> +--------------------+
> | Database           |
> +--------------------+
> | information_schema |
> | mysql              |
> | performance_schema |
> | sys                |
> | test_db63          |
> +--------------------+
> 5 rows in set (0.01 sec)
> 
> mysql> use test_db63;
> Reading table information for completion of table and column names
> You can turn off this feature to get a quicker startup with -A
>
> Database changed
> mysql> show tables;
> +---------------------+
> | Tables_in_test_db63 |
> +---------------------+
> | orders              |
> +---------------------+
> 1 row in set (0.01 sec)
> ```

**Приведите в ответе** количество записей с `price` > 300.

> ```code
> mysql> SELECT * from orders;
> +----+-----------------------+-------+
> | id | title                 | price |
> +----+-----------------------+-------+
> |  1 | War and Peace         |   100 |
> |  2 | My little pony        |   500 |
> |  3 | Adventure mysql times |   300 |
> |  4 | Server gravity falls  |   300 |
> |  5 | Log gossips           |   123 |
> +----+-----------------------+-------+
> 5 rows in set (0.00 sec)
> 
> mysql> SELECT * from orders where price > 300;
> +----+----------------+-------+
> | id | title          | price |
> +----+----------------+-------+
> |  2 | My little pony |   500 |
> +----+----------------+-------+
> 1 row in set (0.00 sec)
> 
> mysql> SELECT COUNT(*) from orders where price > 300;
> +----------+
> | COUNT(*) |
> +----------+
> |        1 |
> +----------+
> 1 row in set (0.00 sec)
> ```

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

> `CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass';`  

- плагин авторизации mysql_native_password
  
> `ALTER USER 'test'@'localhost' IDENTIFIED WITH MYSQL_NATIVE_PASSWORD BY 'test-pass';`

- срок истечения пароля - 180 дней

> `ALTER USER 'test'@'localhost' PASSWORD EXPIRE INTERVAL 180 DAY;`

- количество попыток авторизации - 3

> `ALTER USER 'test'@'localhost' FAILED_LOGIN_ATTEMPTS 3;`

- максимальное количество запросов в час - 100

> `ALTER USER 'test'@'localhost' WITH max_queries_per_hour 100;`

- аттрибуты пользователя:
  - Фамилия "Pretty"
  - Имя "James"

> `ALTER USER 'test'@'localhost' attribute '{"lname": "Pretty", "name": "James"}';`  
>
> можно было одной коммандой  
>
> ```code
> DROP USER 'test'@'localhost';       удалим пользователя и создадим снова
> mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH MYSQL_NATIVE_PASSWORD BY 'test-pass' WITH max_queries_per_hour 100 PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 attribute '{"lname": "Pretty", "name": "James"}';
> Query OK, 0 rows affected (0.01 sec)
>
> mysql> SELECT host, user, max_questions, plugin, password_lifetime, account_locked, User_attributes FROM mysql.user;
> +-----------+------------------+---------------+-----------------------+-------------------+----------------+------------------------------------------------------------------------------------------------------------------------------------+
> | host      | user             | max_questions | plugin                | password_lifetime | account_locked | User_attributes                                                                                                                    |
> +-----------+------------------+---------------+-----------------------+-------------------+----------------+------------------------------------------------------------------------------------------------------------------------------------+
> | %         | root             |             0 | caching_sha2_password |              NULL | N              | NULL                                                                                                                               |
> | localhost | mysql.infoschema |             0 | caching_sha2_password |              NULL | Y              | NULL
>                                                    |
> | localhost | mysql.session    |             0 | caching_sha2_password |              NULL | Y              | NULL
>                                                    |
> | localhost | mysql.sys        |             0 | caching_sha2_password |              NULL | Y              | NULL
>                                                    |
> | localhost | root             |             0 | caching_sha2_password |              NULL | N              | NULL
>                                                    |
> | localhost | test             |           100 | mysql_native_password |               180 | N              | {"metadata": {"name": "James", "lname": "Pretty"}, "Password_locking": {"failed_login_attempts": 3, "password_lock_time_days": 0}} |
> +-----------+------------------+---------------+-----------------------+-------------------+----------------+------------------------------------------------------------------------------------------------------------------------------------+
> 6 rows in set (0.01 sec)
> ```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.  

> ```code
> mysql> GRANT SELECT ON `test_db63`.* TO 'test'@'localhost';
> Query OK, 0 rows affected, 1 warning (0.02 sec)
> 
> mysql> SHOW GRANTS FOR 'test'@'localhost';
> +-----------------------------------------------------+
> | Grants for test@localhost                           |
> +-----------------------------------------------------+
> | GRANT USAGE ON *.* TO `test`@`localhost`            |
> | GRANT SELECT ON `test_db63`.* TO `test`@`localhost` |
> +-----------------------------------------------------+
> 2 rows in set (0.00 sec)
>

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и **приведите в ответе к задаче**.

> ```code
> mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test';
> +------+-----------+--------------------------------------+
> | USER | HOST      | ATTRIBUTE                            |
> +------+-----------+--------------------------------------+
> | test | localhost | {"name": "James", "lname": "Pretty"} |
> +------+-----------+--------------------------------------+
> 1 row in set (0.00 sec)
> ```

## Задача 3

Установите профилирование `SET profiling = 1`.

> ```code
> mysql> SET profiling = 1;
> Query OK, 0 rows affected, 1 warning (0.01 sec)
> ```

Изучите вывод профилирования команд `SHOW PROFILES;`.

> ```code
> mysql> SHOW PROFILES;
> +----------+------------+--------------------------------------------------------------------------------------------------------------+
> | Query_ID | Duration   | Query                                                                                                        |
> +----------+------------+--------------------------------------------------------------------------------------------------------------+
> |        1 | 0.00127550 | SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES                                                             |
> |        2 | 0.00071650 | SELECT host, user, max_questions, plugin, password_lifetime, account_locked, User_attributes FROM mysql.user |
> |        3 | 0.01279025 | SELECT COUNT(*) FROM orders WHERE price > 300                                                                |
> +----------+------------+--------------------------------------------------------------------------------------------------------------+
> 3 rows in set, 1 warning (0.00 sec)
>

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

> ```code
> mysql> SHOW TABLE STATUS \G
> *************************** 1. row ***************************
>            Name: orders
>          Engine: InnoDB
>         Version: 10
>      Row_format: Dynamic
>            Rows: 5
>  Avg_row_length: 3276
>     Data_length: 16384
> Max_data_length: 0
>    Index_length: 0
>       Data_free: 0
>  Auto_increment: 6
>     Create_time: 2022-12-02 12:56:56
>     Update_time: NULL
>      Check_time: NULL
>       Collation: utf8mb4_0900_ai_ci
>        Checksum: NULL
>  Create_options:
>         Comment:
> 1 row in set (0.00 sec)
> 
> mysql> SHOW ENGINES;
> +--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
> | Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
> +--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
> | ndbcluster         | NO      | Clustered, fault-tolerant tables                               | NULL         | NULL | NULL       |
> | FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
> | MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
> | InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
> | PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
> | MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
> | ndbinfo            | NO      | MySQL Cluster system information storage engine                | NULL         | NULL | NULL       |
> | MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
> | BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
> | CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
> | ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
> +--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
> 11 rows in set (0.01 sec)
> ```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:

- на `MyISAM`

> ```code
> mysql> ALTER TABLE orders ENGINE = MyISAM;
> Query OK, 5 rows affected (0.14 sec)
> Records: 5  Duplicates: 0  Warnings: 0
> ```

- на `InnoDB`

> ```code
> mysql> ALTER TABLE orders ENGINE = InnoDB;
> Query OK, 5 rows affected (0.08 sec)
> Records: 5  Duplicates: 0  Warnings: 0
> ```

## Задача 4

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

> у меня файл находится `/etc/my.cnf` что значит (как я понял) параметры настройки будут глобальными  
> использовал [статья 1](https://habr.com/ru/post/539792/) [статья 2](https://highload.today/index-php-2009-04-23-optimalnaya-nastroyka-mysql-servera/) в помощь, ну и [Справочное руководство по MySQL](http://www.mysql.ru/docs/man/InnoDB_start.html)  
>
> ```code
> bash-4.4# cat /etc/my.cnf
> # For advice on how to change settings please see
> # http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html
> 
> [mysqld]
> #
> # Remove leading # and set to the amount of RAM for the most important data
> # cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
> # innodb_buffer_pool_size = 128M
> #
> # Remove leading # to turn on a very important data integrity option: logging
> # changes to the binary log between backups.
> # log_bin
> #
> # Remove leading # to set options mainly useful for reporting servers.
> # The server defaults are faster for transactions and fast SELECTs.
> # Adjust sizes as needed, experiment to find the optimal values.
> # join_buffer_size = 128M
> # sort_buffer_size = 2M
> # read_rnd_buffer_size = 2M
> 
> # Remove leading # to revert to previous value for default_authentication_plugin,
> # this will increase compatibility with older clients. For background, see:
> # https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
> # default-authentication-plugin=mysql_native_password
> skip-host-cache
> skip-name-resolve
> datadir=/var/lib/mysql
> socket=/var/run/mysqld/mysqld.sock
> secure-file-priv=/var/lib/mysql-files
> user=mysql
> 
> pid-file=/var/run/mysqld/mysqld.pid
> 
> # InnoDB parameters
> innodb_flush_log_at_trx_commit = 0
> innodb_file_per_table = 1
> innodb_log_buffer_size = 1M
> innodb_buffer_pool_size = 300M
> innodb_log_file_size = 100M
> 
> [client]
> socket=/var/run/mysqld/mysqld.sock
> 
> !includedir /etc/mysql/conf.d/
> ```
