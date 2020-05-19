#!/usr/bin/env bash

BASEPATH="/home/pi/NetSec"
ERROR_LOG="logs/errorLog.txt"
GEN_LOG="logs/genLog.txt"
FOLDERNAME=$(date +%F-%T)

source /home/pi/NetSec/setup/config.conf

sudo airmon-ng start $IFACE >> $BASEPATH/$GEN_LOG $BASEPATH/$ERROR_LOG
INTERFACE="${IFACE}mon"
# QUICK SCAN
if [ $CAPTURE_TYPE == 'Q' ] || [ $CAPTURE_TYPE == 'q' ]; then
	source ./functions.sh
	quick_scan
# MANUAL SCAN
elif [ $CAPTURE_TYPE == 'M' ] || [ $CAPTURE_TYPE == 'm' ]; then

	if [ $SCAN_TYPE == 'B' ] || [ $SCAN_TYPE == 'b' ]; then
		# BSSID SCAN
		source $BASEPATH/functions.sh
		bssid_scan
	elif [ $SCAN_TYPE == 'E' ] || [ $SCAN_TYPE == 'e' ]; then
		# ESSID SCAN
		source $BASEPATH/functions.sh
		essid_scan	
	elif [ $SCAN_TYPE == 'C' ] || [ $SCAN_TYPE == 'c' ]; then
		# CHANNEL SCAN
		source $BASEPATH/functions.sh
		channel_scan
	else
		echo -e "[!] ERROR - Incorrect Input"
		exit 1
	fi
# CLIENT ATTACK
elif [ $CAPTURE_TYPE == 'C' ] || [ $CAPTURE_TYPE == 'c' ]; then

	if [ $ATTACK_TYPE == 'H' ] || [ $ATTACK_TYPE == 'h' ]; then
		# HIRTE ATTACK
		source $BASEPATH/functions.sh
		hirte_attack
	elif [ $ATTACK_TYPE == 'C' ] || [ $ATTACK_TYPE == 'c' ]; then
		# CAFFE LATTE
		source $BASEPATH/functions.sh
		caffe_latte_attack
	elif [ $ATTACK_TYPE == 'M' ] || [ $ATTACK_TYPE == 'm' ]; then
		# TARGETED MAC ATTACK
		source $BASEPATH/functions.sh
		mac_attack
	else
		echo -e "[!] ERROR - Incorrect Input"
		exit 1
	fi
# INCORRECT INPUT
else
	echo -e "[!] ERROR"
	exit 1
fi
