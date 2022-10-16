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
