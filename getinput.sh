#!/bin/bash

#after kill stop for 2 sec
for (( ; ; ))
do
   echo "infinite tcpdump"
   sudo tcpdump -i lo -w input.pcap
   sleep 2
done
