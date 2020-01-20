#!/bin/bash

two() {
touch /tmp/source
src="/tmp/source"
echo "ipaddress4="$IPV4"" > $src
echo "ipaddress6="$IPV6"" >> $src
echo "macaddress="$MAC"" >> $src
echo "netmask="$NETMASK"" >> $src
echo "broadcast="$BROADCAST"" >> $src
source $src
}

one() {
IPV4=$(ifconfig $interface | grep inet | awk 'FNR == 1 {print}' | awk ' {print $2}')
IPV6=$(ifconfig $interface | grep inet | awk 'FNR == 2 {print}' | awk ' {print $2}')
MAC=$(ifconfig $interface | grep ether | awk ' {print $2}')
NETMASK=$(ifconfig $interface | grep inet | awk 'FNR == 1 {print}' | awk ' {print $4}')
BROADCAST=$(ifconfig $interface | grep inet | awk 'FNR == 1 {print}' | awk ' {print $6}')

echo
echo "Selected interface: $interface"
echo
echo "IPv4 Address: $IPV4"
echo "IPv6 Address: $IPV6"
echo "MAC Address:  $MAC"
echo "Netmask:      $NETMASK"
echo "Broadcast:    $BROADCAST"
echo
echo "Exported as:"
echo
echo "\$ipaddress4  = $IPV4"
echo "\$ipaddress6  = $IPV6"
echo "\$macaddres   = $MAC"
echo "\$netmask     = $NETMASK"
echo "\$broadcast   = $BROADCAST"
echo

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
read -p "manually enter interface (1) let me choose (2): " opt1
if [ "$opt1" = "1" ]; then
read -p "enter interface: " interface
fi
if [ "$opt1" = "2" ]; then
interface=$(route | awk 'FNR == 3 {print}' | awk ' {print $8}')
fi
one
}
zero
