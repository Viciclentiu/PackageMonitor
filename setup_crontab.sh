#!/bin/bash

path_monitor="$(cd -- "$(dirname -- "$0")" && pwd )/monitor.sh"

chmod u+x "$path_monitor"

#monitorul va rula in fiecare ora
(crontab -l | grep -v "$path_monitor"; echo "0 * * * * $path_monitor monitor" ) | crontab - 

