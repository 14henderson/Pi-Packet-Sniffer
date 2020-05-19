Deployable Packet Sniffer Readme
---------------------------------
Download
1) Using Linux and git, run:
	$git clone https://github.com/14henderson/Pi-Packet-Sniffer.git

	

SETUP - Setup.sh
1) Go to the following directory:
	[download location]/setup/
1) To setup a this packet sniffer open enter the following form a terminal open at NetSec:
	$ ./setup.sh

2) Follow the instructions to define your custom packet sniffer

3) Once complete setup.sh will close and inform you of completion

--------------------------
RUNNING THE PACKET SNIFFER

1) Enter the following from a terminal open at NetSec

	$ ./celular-hat.init

2) Packet sniffer will automatically initate once the Cell Hat has successfully initated.

3) If looking to automate process, it is advised to add celular-hat.init as a crontab job:
	$sudo crontab -e
	
	(add to end)
	@reboot [download directory]/celular-init.sh
	
