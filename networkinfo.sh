#!/bin/bash

two() {
touch /tmp/source
src="/tmp/source"
echo "interface="$interface"" > $src
echo "ipaddress4="$IPV4"" >> $src
echo "ipv4range="$IP4RANGE"" >> $src
echo "ipaddress6="$IPV6"" >> $src
echo "ipv6range="$IP6RANGE"" >> $src
echo "macaddress="$MAC"" >> $src
echo "netmask="$NETMASK"" >> $src
echo "broadcast="$BROADCAST"" >> $src

}

one() {
IPV4=$(ifconfig $interface | grep inet | awk 'FNR == 1 {print}' | awk ' {print $2}')
IPV6=$(ifconfig $interface | grep inet | awk 'FNR == 2 {print}' | awk ' {print $2}')
MAC=$(ifconfig $interface | grep ether | awk ' {print $2}')
NETMASK=$(ifconfig $interface | grep inet | awk 'FNR == 1 {print}' | awk ' {print $4}')
BROADCAST=$(ifconfig $interface | grep inet | awk 'FNR == 1 {print}' | awk ' {print $6}')
IP4RANGE=$(ip -4 a show $interface | grep inet | awk ' {print $2}' | tail -c 4)
IP6RANGE=$(ip -6 a show $interface | grep inet6 | awk ' {print $2}' | tail -c 4)

echo
echo "Selected interface: $interface"
echo
echo "Interface:    $interface"
echo "MAC Address:  $MAC"
echo "IPv4 Address: $IPV4"
echo "IPv4 Range:   $IP4RANGE"
echo "IPv6 Address: $IPV6"
echo "IPv6 Range:   $IP6RANGE"
echo "Netmask:      $NETMASK"
echo "Broadcast:    $BROADCAST"
echo
echo "Exported as:"
echo
echo "\$interface   = $interface"
echo "\$macaddres   = $MAC"
echo "\$ipaddress4  = $IPV4"
echo "\$ipv4range   = $IP4RANGE"
echo "\$ipaddress6  = $IPV6"
echo "\$ipv6range   = $IP6RANGE"
echo "\$netmask     = $NETMASK"
echo "\$broadcast   = $BROADCAST"
echo
echo "To use the variables, use the command \"source /tmp/source\""
two

exit 0
}

banner() {
echo "+-----------------------------------------------------+"
echo "| Network info by nox.                                |"
echo "|                                                     |"
echo "| Print networking info and export them as variables. |"
echo "|                                                     |"
echo "| Note: requires net-tools and route                  |"
echo "| make sure ifconfig can see your interface           |"
echo "+-----------------------------------------------------+"
echo
}

zero() {
banner
read -p "Manually enter interface (1) Fetch interface from route (2): " opt1
if [ "$opt1" = "1" ]; then
read -p "enter interface: " interface
fi
if [ "$opt1" = "2" ]; then
interface=$(route | awk 'FNR == 3 {print}' | awk ' {print $8}')
fi
one
}
zero
