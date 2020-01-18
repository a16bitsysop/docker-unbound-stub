# docker-unbound-stub
Dockerfile and scripts to create an unbound image that can be configured with environment variables on run

Environment  variables used:
CPORT = port unbound listens on inside container

FORWARD = configure unbound to forward requests can be: 
"quad9" for 9.9.9.9 and secondary
"google" for 8.8.8.8 and secondary
or any other value uses 1.1.1.1 and secondary

If unset unbound is configured as an authorarive server that queries root servers itself

PREFETCH = If set then prefetch is set in config so unbound keeps common requests fresh

STUBIP = IP of DNS server for local requests eg dnsmasq or mikrotik/openwrt router etc,
If unset no stub zone is configured

STUBPORT = port STUBIP is listening on (Defaults to 53 if unset)

STUBMASK = Bitmask length of local IP range (local bitmask) Defaults to 24 if unset

NTPIP = IP of local/prefered NTP server, sets spoof names for windows and osx servers
If unset no spoof names are added 

NTPNAMES = extra ntp server names to set spoof names to with NTPIP
eg. "ntp.VOIP.com another.remotentp.com"

SPOOFIP = IP to use for SPOOFNAMES
SPOOFNAMES = names to set spoof names to SPOOFIP, sets reverse lookup as well
