#!/bin/sh
echo "celular-init.sh" > /home/pi/NetSec/logs/genLog.txt
echo "celular-init.sh" > /home/pi/NetSec/logs/errorLog.txt

echo "---------------" >> /home/pi/NetSec/logs/genLog.txt
echo "---------------" >> /home/pi/NetSec/logs/errorLog.txt
#take down celular
echo Closing any current open GSM connection... >> /home/pi/NetSec/logs/genLog.txt
nmcli -w 5 connection down GSM\ connection 2>> /home/pi/NetSec/logs/errorLog.txt
sleep 10s
echo Restarting the PiloT hat... >> /home/pi/NetSec/logs/genLog.txt
#Restart the PiloT Hat
#Stop the hat
gpio -g mode 6 out
gpio -g mode 21 out
gpio -g write 6 0
gpio -g write 21 0

#Start the hat
gpio -g write 6 1
gpio -g write 21 1
sleep 2s
gpio -g write 21 0

#Wait for it to startup
gpio -g mode 17 out
gpio -g mode 22 out

echo Waiting for PiloT to power up... >> /home/pi/NetSec/logs/genLog.txt
until nmcli device status | grep gsm > /dev/null 2>> /home/pi/NetSec/logs/errorLog.txt
do
	gpio -g write 17 1
	gpio -g write 22 1
	sleep 5s
	gpio -g write 17 0
	gpio -g write 22 0
	sleep 1s
done


#Attempting to start GSM connection
echo Attempting to start GSM connection... >> /home/pi/NetSec/logs/genLog.txt

sleep 10s

while nmcli device status | grep gsm | grep disconnected > /dev/null 2>> /home/pi/NetSec/logs/errorLog.txt
do
	nmcli -w 0 connection up GSM\ connection > /dev/null 2>> /home/pi/NetSec/logs/errorLog.txt
	gpio -g write 17 1
	sleep 0.3s
	gpio -g write 17 0
	sleep 1s
done

echo Nmcli connecting to GSM network... >> /home/pi/NetSec/logs/genLog.txt
while nmcli device status | grep gsm | grep connecting > /dev/null 2>> /home/pi/NetSec/logs/errorLog.txt
do
	gpio -g write 17 1
	sleep 0.3s
	gpio -g write 17 0
	sleep 0.3s
	gpio -g write 17 1
	sleep 0.3s
        gpio -g write 17 0
	sleep 1s
done

echo Nmcli reporting connection. Testing with ping to google.com. >> /home/pi/NetSec/logs/genLog.txt

until ping -c 1 www.google.com 2>> /home/pi/NetSec/logs/errorLog.txt
do
	gpio -g write 17 1
        sleep 0.3s
        gpio -g write 17 0
        sleep 0.3s
        gpio -g write 17 1
        sleep 0.3s
        gpio -g write 17 0
	sleep 0.3s
        gpio -g write 17 1
        sleep 0.3s
        gpio -g write 17 0
	sleep 1s
done

echo Connected! >> /home/pi/NetSec/logs/genLog.txt
gpio -g write 22 1

sleep 5s
gpio -g write 22 0

echo Launching Sniffer Script >> /home/pi/NetSec/logs/genLog.txt
sudo /home/pi/NetSec/main.sh 2>> /home/pi/NetSec/logs/errorLog.txt



