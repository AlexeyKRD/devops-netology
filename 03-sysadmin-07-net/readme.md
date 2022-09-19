# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

---
### 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
> Linux: `ip a`
> ```commandline
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>    inet 127.0.0.1/8 scope host lo
>       valid_lft forever preferred_lft forever
>    inet6 ::1/128 scope host
>       valid_lft forever preferred_lft forever
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
>    link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
>    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
>       valid_lft 86028sec preferred_lft 86028sec
>    inet6 fe80::a00:27ff:fea2:6bfd/64 scope link
>       valid_lft forever preferred_lft forever
> ```
> Windows cmd: `ipconfig /all`
### 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
> Link Layer Discovery Protocol (LLDP) — протокол канального уровня, позволяющий сетевому оборудованию оповещать оборудование, работающее в локальной сети, о своём существовании и передавать ему свои характеристики, а также получать от него аналогичные сведения.    
> Пакет для linux: `lldpd`   
> `sudo apt install lldpd` - установка пакета  
> `systemctl enable lldpd && systemctl start lldpd` - запуск и добавление в загрузку  
### 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.  
> `VLAN` – виртуальное разделение коммутатора.  
> `sudo apt install vlan` - устанавливаем пакет  
> пример (после ребута все слетит), создаем на интерфейсе eth0, vlan-устройство с id 212, именем интерфейса eth0.212 и ip 192.168.1.212
> ```commandline
> vagrant@vagrant:~$ lsmod | grep 8021q
> vagrant@vagrant:~$ sudo modprobe 8021q
> vagrant@vagrant:~$ lsmod | grep 8021q
> 8021q                  32768  0
> garp                   16384  1 8021q
> mrp                    20480  1 8021q
> vagrant@vagrant:~$ ip -br link
> lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
> eth0             UP             08:00:27:a2:6b:fd <BROADCAST,MULTICAST,UP,LOWER_UP>
> vagrant@vagrant:~$ sudo ip link add link eth0 name eth0.212 type vlan id 212
> vagrant@vagrant:~$ sudo ip addr add 192.168.1.212/24 dev eth0.212
> vagrant@vagrant:~$ sudo ip link set dev eth0.212 up
> vagrant@vagrant:~$ ip -c a
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>    inet 127.0.0.1/8 scope host lo
>       valid_lft forever preferred_lft forever
>    inet6 ::1/128 scope host
>       valid_lft forever preferred_lft forever
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
>    link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
>    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
>       valid_lft 85274sec preferred_lft 85274sec
>    inet6 fe80::a00:27ff:fea2:6bfd/64 scope link
>       valid_lft forever preferred_lft forever
> 3: eth0.212@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
>    link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
>    inet 192.168.1.212/24 scope global eth0.212
>       valid_lft forever preferred_lft forever
>    inet6 fe80::a00:27ff:fea2:6bfd/64 scope link
>       valid_lft forever preferred_lft forever
> ```
> чтобы не слетало при reboot'e вносим измененния в конфиг файл `/etc/netplan/01-netcfg.yaml`  
> ```commandline
> vagrant@vagrant:~$ cat /etc/netplan/01-netcfg.yaml
> network:
>   version: 2
>   ethernets:
>     eth0:
>       dhcp4: true
>   vlans:
>       vlan212:
>           id: 212
>           link: eth0
>           addresses: [192.168.1.212/24]
> vagrant@vagrant:~$ sudo netplan apply
> vagrant@vagrant:~$ ip -br -c l
> lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
> eth0             UP             08:00:27:a2:6b:fd <BROADCAST,MULTICAST,UP,LOWER_UP>
> vlan212@eth0     UP             08:00:27:a2:6b:fd <BROADCAST,MULTICAST,UP,LOWER_UP>
> ```
### 4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
> Bonding – это объединение сетевых интерфейсов по определенному типу агрегации, Служит для увеличения пропускной способности и/или отказоустойчивость сети.  
> Типы агрегации интерфейсов в Linux:  
> Mode-0(balance-rr) – Данный режим используется по умолчанию. Balance-rr обеспечивается балансировку нагрузки и отказоустойчивость. В данном режиме сетевые пакеты отправляются “по кругу”, от первого интерфейса к последнему. Если выходят из строя интерфейсы, пакеты отправляются на остальные оставшиеся. Дополнительной настройки коммутатора не требуется при нахождении портов в одном коммутаторе. При разностных коммутаторах требуется дополнительная настройка.  
> Mode-1(active-backup) – Один из интерфейсов работает в активном режиме, остальные в ожидающем. При обнаружении проблемы на активном интерфейсе производится переключение на ожидающий интерфейс. Не требуется поддержки от коммутатора.  
> Mode-2(balance-xor) – Передача пакетов распределяется по типу входящего и исходящего трафика по формуле ((MAC src) XOR (MAC dest)) % число интерфейсов. Режим дает балансировку нагрузки и отказоустойчивость. Не требуется дополнительной настройки коммутатора/коммутаторов.  
> Mode-3(broadcast) – Происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость. Рекомендуется только для использования MULTICAST трафика.  
> Mode-4(802.3ad) – динамическое объединение одинаковых портов. В данном режиме можно значительно увеличить пропускную способность входящего так и исходящего трафика. Для данного режима необходима поддержка и настройка коммутатора/коммутаторов.  
> Mode-5(balance-tlb) – Адаптивная балансировки нагрузки трафика. Входящий трафик получается только активным интерфейсом, исходящий распределяется в зависимости от текущей загрузки канала каждого интерфейса. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.  
> Mode-6(balance-alb) – Адаптивная балансировка нагрузки. Отличается более совершенным алгоритмом балансировки нагрузки чем Mode-5). Обеспечивается балансировку нагрузки как исходящего так и входящего трафика. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.  
> Вносим изменения в конфиг файл `/etc/netplan/01-netcfg.yaml`  
> ```commandline
>  bonds:
>    bond0:
>      addresses: [192.168.1.123/24]
>      interfaces: [eth1, eth2]
>      parameters:
>        mode: active-backup
>        mii-monitor-interval: 1
> ```
### 5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
> 8 IP адресов в сети с маской /29, из них 6 для хостов.  
> В сети с маской /24 256 адресов, а в сети с маской /29 8 адресов, включаем математику) 256:8=32, получается 32 подсети можно получить.   
> также можно получить по запросу `ipcalc 10.10.10.0/24 /29` получим 32 подсети и 192 хоста.    
> 10.10.10.0/29, 10.10.10.8/29, 10.10.10.16/29, 10.10.10.24/29, 10.10.10.32/29 и т.д.  
> ```commandline
> vagrant@vagrant:~$ ipcalc 10.10.10.0/24
> Address:   10.10.10.0           00001010.00001010.00001010. 00000000
> Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
> Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
> =>
> Network:   10.10.10.0/24        00001010.00001010.00001010. 00000000
> HostMin:   10.10.10.1           00001010.00001010.00001010. 00000001
> HostMax:   10.10.10.254         00001010.00001010.00001010. 11111110
> Broadcast: 10.10.10.255         00001010.00001010.00001010. 11111111
> Hosts/Net: 254                   Class A, Private Internet
> 
> vagrant@vagrant:~$ ipcalc 10.10.10.0/29
> Address:   10.10.10.0           00001010.00001010.00001010.00000 000
> Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
> Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
> =>
> Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
> HostMin:   10.10.10.1           00001010.00001010.00001010.00000 001
> HostMax:   10.10.10.6           00001010.00001010.00001010.00000 110
> Broadcast: 10.10.10.7           00001010.00001010.00001010.00000 111
> Hosts/Net: 6                     Class A, Private Internet
> ```
### 6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
> 40-50 хостов не получится) ибо 30 хостов (/27) а 62 (/26), используем тогда 100.64.0.0/26  
> Wikipedia: )  
> 10.0.0.0 — 10.255.255.255 (маска подсети для бесклассовой (CIDR) адресации: 10.0.0.0 или /8)  
> 100.64.0.0 — 100.127.255.255 (маска подсети 255.192.0.0 или /10) - Данная подсеть рекомендована согласно RFC 6598 для использования в качестве адресов для CGN (Carrier-Grade NAT).  
> 172.16.0.0 — 172.31.255.255 (маска подсети: 255.240.0.0 или /12)  
> 192.168.0.0 — 192.168.255.255 (маска подсети: 255.255.0.0 или /16)
### 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
> Linux:  
> `ip neighbour`, `ip neigh show` - просмотреть таблицу  
> `ip neighbour flush` - очистить записи таблицы о соседних хостах    
> `ip neigh del [ip_address] dev [interface]` - удалить определенный ip  
> Windows:  
> `arp -a` - просмотреть таблицу  
> `netsh interface ip delete arpcache` - очистить записи таблицы  
> `arp -d [ip_address]` - удалить определенный ip  