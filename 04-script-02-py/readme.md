# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- |--|
| Какое значение будет присвоено переменной `c`?  | Ошибка будет |
| Как получить для переменной `c` значение 12?  | c = str(a) + b |
| Как получить для переменной `c` значение 3?  | c = a + int(b) |


## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
wdir = os.popen("pwd").read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = wdir.strip() + result.replace('\tmodified:   ', '/')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@serv:~/netology/sysadm-homeworks$ python3 2.py
/home/vagrant/netology/sysadm-homeworks/1.py
/home/vagrant/netology/sysadm-homeworks/2.py
/home/vagrant/netology/sysadm-homeworks/log/text.txt
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

while True:
    wdir = input('Введите путь к репо: ')
    bash_command = ["cd " + wdir, "git status"]
    if os.path.exists(wdir):
        print(wdir + ' Путь существует')
        result_os = os.popen(' && '.join(bash_command)).read()
        for result in result_os.split('\n'):
            if result.find('modified') != -1:
                prepare_result = wdir.strip() + result.replace('\tmodified:   ', '/')
                print(prepare_result)
    else:
        print(wdir + ' Путь НЕ существует')
    ext = input('Продолжть? y/n ')
    if ext == 'n':
        break
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@serv:~/netology/sysadm-homeworks$ python3 3.py
Введите путь к репо: /temp
/temp Путь НЕ существует
Продолжть? y/n y
Введите путь к репо: /home/vagrant/netology/sysadm-homeworks
/home/vagrant/netology/sysadm-homeworks Путь существует
/home/vagrant/netology/sysadm-homeworks/1.py
/home/vagrant/netology/sysadm-homeworks/2.py
/home/vagrant/netology/sysadm-homeworks/log/text.txt
Продолжть? y/n
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
import socket as s
import time

web = {
    'drive.google.com'  : '0.0.0.0',
    'mail.google.com'   : '0.0.0.0',
    'google.com'        : '0.0.0.0'
        }

while True:
    for hst in web:
        ip = s.gethostbyname(hst)
        if web[hst] == ip:
            print(hst + ' - ' + ip)
        else:
            print('[ERROR] ' + hst + ' IP mismatch: ' + web[hst] + ' > ' + ip)
            web[hst] = ip
    time.sleep(2)
```

### Вывод скрипта при запуске при тестировании:
```
[ERROR] drive.google.com IP mismatch: 0.0.0.0 > 74.125.205.194
[ERROR] mail.google.com IP mismatch: 0.0.0.0 > 64.233.162.17
[ERROR] google.com IP mismatch: 0.0.0.0 > 64.233.165.139
drive.google.com - 74.125.205.194
[ERROR] mail.google.com IP mismatch: 64.233.162.17 > 64.233.162.18
[ERROR] google.com IP mismatch: 64.233.165.139 > 64.233.165.138
drive.google.com - 74.125.205.194
[ERROR] mail.google.com IP mismatch: 64.233.162.18 > 64.233.162.17
[ERROR] google.com IP mismatch: 64.233.165.138 > 64.233.165.139
drive.google.com - 74.125.205.194
[ERROR] mail.google.com IP mismatch: 64.233.162.17 > 64.233.162.83
[ERROR] google.com IP mismatch: 64.233.165.139 > 64.233.165.101
```