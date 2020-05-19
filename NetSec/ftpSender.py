#!/usr/bin/env python

import os, time, sys
sys.path.append('/home/pi/.local/lib/python3.7/site-packages')
print(sys.path)

import pysftp

path = '/home/packets/'



cnopts = pysftp.CnOpts()
cnopts.hostkeys = None


with pysftp.Connection("######", username="####", password="#####", cnopts=cnopts) as sftp:
        for foldername in os.listdir('/home/pi/NetSec/captures'):

                localpath = '/home/pi/NetSec/captures/'+foldername+'/'
                remotepath = path+foldername

                if sftp.isdir(remotepath):
                        print(remotepath+" already exists!")
                        continue
                else:
                        print("making: ", remotepath)
                        sftp.mkdir(remotepath)

                for file in os.listdir(localpath):
                        localpath = '/home/pi/NetSec/captures/'+foldername+'/'+file
                        remotepath = path+foldername+'/'+file
                        print(localpath, "        ", remotepath)
                        sftp.put(localpath, remotepath)
