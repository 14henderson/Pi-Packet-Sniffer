#!/bin/bash

BASEPATH="/home/pi/NetSec"
ERROR_LOG="logs/errorLog.txt"
SETUP_LOG="logs/setupLog.txt"
FOLDERNAME=$(date +%F-%T)

echo -e "**********************************************"		 
echo -e "*             SETUP PACKET SNIFFER           *"
echo -e "**********************************************" 
echo -e "[*] Setup & Save Packet Sniffer Configuration"
echo -e "[*]CTRL+Z to quit at anytime\n"

# DEFINE DESIRED INTERFACE AND DURATION OF BLOCKS OF PACKET CAPTURE
echo -e "--- INITIAL SETUP OPTIONS ---"
echo -e "> Specify desired interface (e.g. wlan1): " 
read -p ">>> " SETUP_IFACE
echo -e "> Specify duration of packet capture loops (in seconds): " 
read -p ">>> " SETUP_DURATION

# WRITE DURATION AND INTERRFACE TO CONFIG FILE
sed -i -e "s/^IFACE=.*/IFACE=$SETUP_IFACE/" -e "s/^DURATION=.*/DURATION=$SETUP_DURATION/" config.conf

# DEFINE TYPE OF PACKET CAPTURE OR ATTACK
echo -e "\n--- SPECIFY TYPE OF CAPTURE OR ATTACK ---"
echo -e "> [Q]uick Packet Sniffer \n> [M]anual Packet Sniffer \n> [C]lient Attack"
read -p ">>> " SETUP_CAPTURE_TYPE

# WRITE CAPTURE TYPE TO CONFIG FILE 
sed -i -e "s/^CAPTURE_TYPE=.*/CAPTURE_TYPE=$SETUP_CAPTURE_TYPE/" config.conf

# QUICK SCAN
if [ $SETUP_CAPTURE_TYPE == 'Q' ] || [ $SETUP_CAPTURE_TYPE == 'q' ]; then
		echo -e "[!] Setup Complete \n[!] EXITING..."
		exit 1
# IF MANUAL SELECTED	
elif [ $SETUP_CAPTURE_TYPE == 'M' ] || [ $SETUP_CAPTURE_TYPE == 'm' ]; then

	# DEFINE SETUP OF MANUAL CAPTURE
	echo -e "\n--- SPECIFY MANUAL CAPTURE SETUP ---"
	echo -e "> [B]SSID Scan, [E]SSID Scan, [C]hannel Scan: "
	read -p ">>> " SETUP_MANUAL_SCAN_TYPE
	
	# WRITE MANUAL METHOD TO CONFIG FILE 
	sed -i -e "s/^SCAN_TYPE=.*/SCAN_TYPE=$SETUP_MANUAL_SCAN_TYPE/" config.conf
	
	if [ $SETUP_MANUAL_SCAN_TYPE == 'B' ] || [ $SETUP_MANUAL_SCAN_TYPE == 'b' ]; then
	
		echo -e "> Specify target BSSID (Address)"
		read -p ">>> " SETUP_BSSID
		
		sed -i -e "s/^SCAN_TARGET=.*/SCAN_TARGET=$SETUP_BSSID/" config.conf
		
		echo -e "[!] Setup Complete \n[!] EXITING..."
		exit 1
		
	elif [ $SETUP_MANUAL_SCAN_TYPE == 'E' ] || [ $SETUP_MANUAL_SCAN_TYPE == 'e' ]; then
	
		echo -e "> Specify target ESSID (Name)"
		read -p ">>> " SETUP_ESSID
		
		sed -i -e "s/^SCAN_TARGET=.*/SCAN_TARGET=$SETUP_ESSID/" config.conf
		
		echo -e "[!] Setup Complete \n[!] EXITING..."
		exit 1
		
	elif [ $SETUP_MANUAL_SCAN_TYPE == 'C' ] || [ $SETUP_MANUAL_SCAN_TYPE == 'c' ]; then
	
		echo -e "> Specify target channel(s) (Single # of multiple #,#,#)"
		read -p ">>> " SETUP_CHANNEL
		
		sed -i -e "s/^SCAN_TARGET=.*/SCAN_TARGET=$SETUP_CHANNEL/" config.conf
		
		echo -e "[!] Setup Complete \n[!] EXITING..."
		exit 1
		
	else
		echo -e "[!] ERROR - Incorrect input"
	fi

# IF CLIENT ATTACK SELECTED
elif [ $SETUP_CAPTURE_TYPE == 'C' ] || [ $SETUP_CAPTURE_TYPE == 'c' ]; then
	echo -e "\n--- CLIENT ATTACK SETUP ---"
	echo -e "> [H]irte Attack, [C]affe Latte Attack, Targeted [M]AC Attack"
	read -p ">>> " SETUP_ATTACK_TYPE
	
	sed -i -e "s/^ATTACK_TYPE=.*/ATTACK_TYPE=$SETUP_ATTACK_TYPE/" config.conf
	
	if [ $SETUP_ATTACK_TYPE = 'H' ] || [ $SETUP_ATTACK_TYPE = 'H' ]; then
		echo -e "> Specify Channel: "
		read -p ">>> " SETUP_ATTACK_CHANNEL
		echo -e "> Specify Name for Fake WEP AP: "
		read -p ">>> " SETUP_FAKE_AP
		
		sed -i -e "s/^ATTACK_CHANNEL=.*/ATTACK_CHANNEL=$SETUP_ATTACK_CHANNEL/" -e "s/^FAKE_AP=.*/FAKE_AP=$SETUP_FAKE_AP/" config.conf
	
	elif [ $SETUP_ATTACK_TYPE = 'C' ] || [ $SETUP_ATTACK_TYPE = 'c' ]; then
		echo -e "> Specify Channel: "
		read -p ">>> " SETUP_ATTACK_CHANNEL
		echo -e "> Specify Name for Fake WEP AP: "
		read -p ">>> " SETUP_FAKE_AP
		
		sed -i -e "s/^ATTACK_CHANNEL=.*/ATTACK_CHANNEL=$SETUP_ATTACK_CHANNEL/" -e "s/^FAKE_AP=.*/FAKE_AP=$SETUP_FAKE_AP/" config.conf
		
	elif [ $SETUP_ATTACK_TYPE = 'M' ] || [ $SETUP_ATTACK_TYPE = 'm' ]; then
		echo -e "> Specify Channel: "
		read -p ">>> " SETUP_ATTACK_CHANNEL
		echo -e "> Specify Target MAC Address: "
		read -p ">>> " SETUP_TARGET_MAC
		
		sed -i -e "s/^ATTACK_CHANNEL=.*/ATTACK_CHANNEL=$SETUP_ATTACK_CHANNEL/" -e "s/^TARGET_MAC=.*/TARGET_MAC=$SETUP_TARGET_MAC/" config.conf
		
	else
		echo -e "[!] ERROR - Incorrect Input"
		exit 1
	fi


# IF AN INCORRECT INPUT
else
	echo -e "[!] ERROR - Incorrect Input"
fi
