
# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
{ "info": "Sample JSON output from our service\t",
  "elements": [
    {
      "ip": 7175,
      "name": "first",
      "type": "server"
    },
    {
      "ip": "71.78.22.43",
      "name": "second",
      "type": "proxy"
    }
  ]
}
```
 Не хватало кавычек в "ip" : "71.78.22.43" 
 Доработка: запятой в списке нехватало), прогнал через свой parser.py он мне подсказал))

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
import socket as s
import time
import json
import yaml

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
            with open('hstip.json', 'w') as js_file:
                js_file.write(json.dumps(web, indent=2))
            with open('hstip.yaml', 'w') as yml_file:
                yml_file.write(yaml.dump(web, explicit_start=True, explicit_end=True))

    time.sleep(2)
```

### Вывод скрипта при запуске при тестировании:
```
[ERROR] drive.google.com IP mismatch: 0.0.0.0 > 173.194.222.194
[ERROR] mail.google.com IP mismatch: 0.0.0.0 > 108.177.14.83
[ERROR] google.com IP mismatch: 0.0.0.0 > 74.125.131.139
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 108.177.14.83 > 108.177.14.18
[ERROR] google.com IP mismatch: 74.125.131.139 > 74.125.131.113
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 108.177.14.18 > 108.177.14.83
[ERROR] google.com IP mismatch: 74.125.131.113 > 74.125.131.139
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
  "drive.google.com": "173.194.222.194",
  "mail.google.com": "108.177.14.83",
  "google.com": "74.125.131.139"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
drive.google.com: 173.194.222.194
google.com: 74.125.131.139
mail.google.com: 108.177.14.83
...
```
## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
import json
import yaml
import os

file = 'bad.yaml'
file_name = os.path.splitext(file)[0]
# print(file_name)
is_json = True
is_yaml = True
error = ''

file = input('Enter file name: ')
if os.path.isfile(file):
    with open(file, 'r') as o_file:
        try:
            dict = json.load(o_file)
            # print(dict)
        except Exception as err:
            # print(file + ' - NOT json file')
            # print(type(err))
            # print(err.args)
            error += '\nError open JSON file: ' + str(err)
            is_json = False
    with open(file, 'r') as o_file:
        try:
            dict = yaml.safe_load(o_file)
            # print(dict)
        except Exception as err:
            # print(file + ' - NOT yaml file')
            # print(type(err))
            # print(err.args)
            error += '\nError open YAML file: ' + str(err)
            is_yaml = False
    if is_json:
        print('create file: re_'+ file_name + '.yaml')
        with open('re_' + file_name + '.yaml', 'w') as yml_file:
            yml_file.write(yaml.dump(dict, indent=2))
    elif is_yaml:
        print('create file: re_'+ file_name + '.json')
        with open('re_' + file_name + '.json', 'w') as jsn_file:
            jsn_file.write(json.dumps(dict, indent=2))
    else:
        print('NOT json AND yaml file' + error)
else:
    print(file + ' - DOES not exist')
```

### Пример работы скрипта:
```commandline
Enter file name: bad.yaml
NOT json AND yaml file
Error open JSON file: Expecting value: line 1 column 1 (char 0)
Error open YAML file: mapping values are not allowed here
  in "bad.yaml", line 3, column 12
```
```commandline
Enter file name: bad.json
create file: re_bad.yaml
```