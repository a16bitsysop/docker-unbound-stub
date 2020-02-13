# docker-unbound-stub
Dockerfile to install [unbound](https://www.nlnetlabs.nl/projects/unbound/about/) as a docker container that can be a forwarding or authorative DNS server, a seperate directory is used for user configuration if required.

Default verbosity changed to reduce logs, for temporary increase in logging use:

```
unbound-control verbosity 2

```
then  to reduce logging again 

```
unbound-control verbosity 1

```

[![Docker Pulls](https://img.shields.io/docker/pulls/a16bitsysop/unbound-stub.svg?style=flat-square)](https://hub.docker.com/r/a16bitsysop/unbound-stub/)
[![Docker Stars](https://img.shields.io/docker/stars/a16bitsysop/unbound-stub.svg?style=flat-square)](https://hub.docker.com/r/a16bitsysop/unbound-stub/)
[![](https://images.microbadger.com/badges/version/a16bitsysop/unbound-stub.svg)](https://microbadger.com/images/a16bitsysop/unbound-stub "Get your own version badge on microbadger.com")

## Github
Github Repository: [https://github.com/a16bitsysop/docker-unbound-stub](https://github.com/a16bitsysop/docker-unbound-stub)

## Environment Variables
| Name       | Desription                                                                                                      | Default             |
| ---------- | --------------------------------------------------------------------------------------------------------------- | ------------------- |
| CPORT      | port unbound listens on inside container                                                                        | 53                  |
| FORWARD    | configure unbound to forward to "quad9","google", or any other value uses 1.1.1.1.  When unset  unbound is configured as an authorarive server that queries root servers itself | unset (Authorative) |
| PREFETCH   | Prefetch frequently requested names to keep fresh if set                                                        | unset (No Prefetch) |
| STUBIP     | IP of DNS server for local requests eg dnsmasq or mikrotik/openwrt router etc, the stub domain is read from resolv.conf. If STUBIP is unset no stub zone is configured | unset |
| STUBPORT   | port STUBIP is listening on                                                                                     | 53                  |
| STUBMASK   | Bitmask length of local IP range                                                                                | 24                  |
| NTPIP      | IP of local/prefered NTP server, sets spoof names for windows and osx servers If unset no spoof names are added | unset               |
| NTPNAMES   | extra ntp server names to set spoof names to with NTPIP eg. "ntp.VOIP.com another.remotentp.com"                | unset               |
| SPOOFIP    | IP to use for SPOOFNAMES                                                                                        | unset               |
| SPOOFNAMES | names to set spoof names to SPOOFIP, sets reverse lookup as well                                                | unset               |

## Examples
###local fowarding over ssl dns resolver with prefetch and other options

```
docker container run -p 53:53/udp --env FORWARD=one --env PREFETCH=yes --env STUBIP=192.168.0.1 --env NTPIP=192.168.0.2 --env NTPNAMES="ntp.voip.net ntp.another.com" --env SPOOFIP=192.168.0.2 --env SPOOFNAMES="mail.example.com another.service.com" --restart unless-stopped --name unbound-forward -d a16bitsysop/unbound-stub
```

###container authorative dns (no ports exposed outside container network)

```
docker container run --net MYNET --env STUBIP=192.168.0.1 --restart unless-stopped --name unbound-root -d a16bitsysop/unbound-stub
```
