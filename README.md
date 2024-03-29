# docker-unbound-stub
Alpine based Dockerfile to install [unbound](https://www.nlnetlabs.nl/projects/unbound/about/) as a docker container that can be a forwarding or authorative DNS server, a seperate directory is used for user configuration if required.

This repository has moved to: https://gitlab.com/container-email/unbound-stub

[![Docker Pulls](https://img.shields.io/docker/pulls/a16bitsysop/unbound-stub.svg?style=plastic)](https://hub.docker.com/r/a16bitsysop/unbound-stub/)
[![Docker Stars](https://img.shields.io/docker/stars/a16bitsysop/unbound-stub.svg?style=plastic)](https://hub.docker.com/r/a16bitsysop/unbound-stub/)
[![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/a16bitsysop/unbound-stub/latest?style=plastic)](https://hub.docker.com/r/a16bitsysop/unbound-stub/)
[![Github SHA](https://img.shields.io/badge/dynamic/json?style=plastic&color=orange&label=Github%20SHA&query=object.sha&url=https%3A%2F%2Fapi.github.com%2Frepos%2Fa16bitsysop%2Fdocker-unbound-stub%2Fgit%2Frefs%2Fheads%2Fmain)](https://github.com/a16bitsysop/docker-unbound-stub)

Default verbosity changed to reduce logs, for temporary increase in logging use:

```bash
unbound-control verbosity 2

```bash
then  to reduce logging again

```bash
unbound-control verbosity 1

```

## Github
Github Repository: [https://github.com/a16bitsysop/docker-unbound-stub](https://github.com/a16bitsysop/docker-unbound-stub)

## Environment Variables
| Name       | Desription                                                                                                      | Default             |
| ---------- | --------------------------------------------------------------------------------------------------------------- | ------------------- |
| CPORT      | port unbound listens on inside container                                                                        | 53                  |
| FORWARD    | configure unbound to forward to "quad9","google", or for clouldflare "1mal" is malware blocking, "1fam" is malware and adult blocking, any other value uses 1.1.1.1.  When unset  unbound is configured as an authorarive server that queries root servers itself | unset (Authorative) |
| PREFETCH   | Prefetch frequently requested names to keep fresh if set                                                        | unset (No Prefetch) |
| STUBIP     | IP of DNS server for local requests eg dnsmasq or mikrotik/openwrt router etc, the stub domain is read from resolv.conf. If STUBIP is unset no stub zone is configured | unset |
| STUBPORT   | port STUBIP is listening on                                                                                     | 53                  |
| STUBMASK   | Bitmask length of local IP range                                                                                | 24                  |
| NTPIP      | IP of local/prefered NTP server, sets spoof names for windows and osx servers If unset no spoof names are added | unset               |
| NTPNAMES   | extra ntp server names to set spoof names to with NTPIP eg. "ntp.VOIP.com another.remotentp.com"                | unset               |
| SPOOFIP    | IP to use for SPOOFNAMES                                                                                        | unset               |
| SPOOFNAMES | names to set spoof names to SPOOFIP, sets reverse lookup as well                                                | unset               |
| LOGIDENT   | name to use for logging                                                                                         | unbound             |
| TIMEZONE   | Timezone to use inside the container, eg Europe/London                                                          | unset               |

## Examples
**local fowarding over ssl dns resolver with prefetch and other options**

```bash
docker container run -p 53:53/udp --env FORWARD=one --env PREFETCH=yes --env STUBIP=192.168.0.1 --env NTPIP=192.168.0.2 --env NTPNAMES="ntp.voip.net ntp.another.com" --env SPOOFIP=192.168.0.2 --env SPOOFNAMES="mail.example.com another.service.com" --restart unless-stopped --name unbound-forward -d a16bitsysop/unbound-stub
```

**container authorative dns (no ports exposed outside container network)**

```bash
docker container run --net MYNET --env STUBIP=192.168.0.1 --restart unless-stopped --name unbound-root -d a16bitsysop/unbound-stub
```
