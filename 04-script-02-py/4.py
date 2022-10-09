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