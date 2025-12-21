#!/bin/bash
#Se vor crea fisierele destinatie
log="/var/log/dpkg.log"  
dest_f="$HOME/rezultate"
last_check="$dest_f/last_check.txt"
newest="$dest_f/newest.txt"
mkdir -p "dest_f"
#cauta pachetele deja instalate
actual=$(grep " status installed " "$log")



