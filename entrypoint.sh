#!/bin/sh
#display environment variables passed with --env

revip()
{
[ -z "$2" ] && need=4 || need="$2"
IFS="." && set -- $1 && IFS=" "
case "$need" in
1) REVIP="$1" && PAD="0.0.0" && STIP="$1.$PAD";;
2) REVIP="$2.$1" && PAD="0.0" && STIP="$1.$2.$PAD";;
3) REVIP="$3.$2.$1" && PAD="0" && STIP="$1.$2.$3.$PAD";;
*) REVIP="$4.$3.$2.$1";;
esac
}

echo "Starting unbound at $(date +'%x %X')"
echo '$CPORT=' $CPORT
echo '$FORWARD=' $FORWARD
echo '$PREFETCH=' $PREFETCH
echo '$STUBIP=' $STUBIP
echo '$STUBPORT=' $STUBPORT
echo '$STUBMASK=' $STUBMASK
echo '$NTPIP=' $NTPIP
echo '$NTPNAMES=' $NTPNAMES
echo '$SPOOFIP=' $SPOOFIP
echo '$SPOOFNAMES=' $SPOOFNAMES
echo
cd /etc/unbound/unbound.conf.d

echo "server:" > auto.conf
[ -n "$PREFETCH" ] && echo "  prefetch: yes" >> auto.conf
[ -n "$CPORT" ] && echo "  port: $CPORT" >> auto.conf

if [ -z "$FORWARD" ]; then
	echo "Configuring authorative DNS"
	echo "  root-hints: 'root.hints'" >> auto.conf

else
	echo "Configuring DNS forwarding to $FORWARD"
	case "$FORWARD" in

	quad9)	DNS1=9.9.9.9
		DNS2=149.112.112.112
		;;
	google)	DNS1=8.8.8.8
		DNS2=8.8.4.4
		;;
	1mal)	DNS1=1.1.1.2
		DNS2=1.0.0.2
		;;
	1fam)	DNS1=1.1.1.3
		DNS2=1.0.0.3
		;;
	*)	DNS1=1.1.1.1
		DNS2=1.0.0.1
		;;
	esac

# port 853 is for ssl communication
	echo "  forward-zone:
  name: \".\"
  forward-ssl-upstream: yes
  forward-addr: $DNS1@853
  forward-addr: $DNS2@853" >> auto.conf
fi

if [ -n "$STUBIP" ]; then
	DOMAIN=$(grep -e search /etc/resolv.conf | cut -d " " -f2)
	[ -z "$DOMAIN" ] && exit "No search domain in /etc/resolv.conf"
	[ -z "$STUBMASK" ] && STUBMASK="24"
	[ -z "$STUBPORT" ] && STUBPORT="53"
	case "$STUBMASK" in

        	8)      revip $STUBIP 1
                ;;
        	16|12)  revip $STUBIP 2
                ;;
        	*)      revip $STUBIP 3
                ;;
        esac

echo "server:
  unblock-lan-zones: yes
  insecure-lan-zones: yes
  do-not-query-localhost: no
  private-address: \"$STIP/$STUBMASK\"
  private-domain: \"$DOMAIN.\"
  domain-insecure: \"$DOMAIN.\"
  caps-whitelist: \"$DOMAIN.\"
  private-domain: \"$REVIP.in-addr.arpa.\"
  domain-insecure: \"$REVIP.in-addr.arpa.\"
  caps-whitelist: \"$REVIP.in-addr.arpa.\"
  local-zone: \"$REVIP.in-addr.arpa.\" nodefault

stub-zone:
 name: \"$DOMAIN\"
 stub-addr: $STUBIP@$STUBPORT
stub-zone:
 name: \"$REVIP.in-addr.arpa.\"
 stub-addr: $STUBIP@$STUBPORT
" > stub.conf
fi

if [ -n "$NTPIP" ]; then
  echo "server:
  local-data: \"time.windows.com. IN A $NTPIP\"
  local-data: \"time.apple.com. IN A $NTPIP\"
  local-data: \"time.euro.apple.com. IN A $NTPIP\"
  local-data: \"time.asia.apple.com. IN A $NTPIP\"
" > ntp-spoof.conf
  if [ -n "$NTPNAMES" ]; then
    for name in ""$NTPNAMES""; do
      echo "local-data: \"$name. IN A $NTPIP\"" >> ntp-spoof.conf
    done
  fi
fi

if [ -n "$SPOOFIP" ] && [ -n "$SPOOFNAMES" ]; then
 revip $SPOOFIP
  if [ -n "$SPOOFNAMES" ]
  then
    echo "server:" > spoof.conf
    for name in ""$SPOOFNAMES""; do
      echo "  local-data: \"$name. IN A $SPOOFIP\"
  local-data: \"$REVIP.in-addr.arpa. IN PTR $name.\"" >> spoof.conf
    done
  fi
fi

cd /etc/unbound
unbound-anchor -a root.key
if [ ! -f unbound_server.key ] || [ ! -f unbound_server.pem ]
then
	unbound-control-setup
fi

chown -R unbound:unbound /etc/unbound

exec unbound -d
