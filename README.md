# docker-unbound-stub
Dockerfile and scripts to create an unbound image that can be configured with environment variables on run

Extra configuration is possible my mounting a volume into /etc/unbound/local.conf.d with more .conf files in

Environment  variables used:

CPORT = port unbound listens on inside container (unbound default 53)

FORWARD = configure unbound to forward requests can be: 
"quad9" for 9.9.9.9 , "google" for 8.8.8.8 , any other value uses 1.1.1.1 
secondary DNS is set for each as well.

If unset unbound is configured as an authorarive server that queries root servers itself

PREFETCH = If set then prefetch is set in config so unbound keeps common requests fresh

STUBIP = IP of DNS server for local requests eg dnsmasq or mikrotik/openwrt router etc,
the stub domain is read from resolv.conf. If STUBIP is unset no stub zone is configured

STUBPORT = port STUBIP is listening on (Defaults to 53 if unset)

STUBMASK = Bitmask length of local IP range (local bitmask) Defaults to 24 if unset

NTPIP = IP of local/prefered NTP server, sets spoof names for windows and osx servers
If unset no spoof names are added 

NTPNAMES = extra ntp server names to set spoof names to with NTPIP
eg. "ntp.VOIP.com another.remotentp.com"

SPOOFIP = IP to use for SPOOFNAMES

SPOOFNAMES = names to set spoof names to SPOOFIP, sets reverse lookup as well

##local fowarding over ssl dns resolver with prefetch and other options

```
docker container run -p 53:53/udp --env FORWARD=one --env PREFETCH=yes --env STUBIP=192.168.0.1 --env NTPIP=192.168.0.2 --env NTPNAMES="ntp.voip.net ntp.another.com" --env SPOOFIP=192.168.88.2 --env SPOOFNAMES="mail.example.com another.service.com" --restart unless-stopped --name unbound-forward -d a16bitsysop/unbound-stub
```

##container authorative dns (no ports exposed outside container network)

```
docker container run --net MYNET --env STUBIP=192.168.88.1 --restart unless-stopped --name unbound-root -d a16bitsysop/unbound-stub
```
