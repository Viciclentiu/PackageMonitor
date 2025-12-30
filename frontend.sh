#!/bin/bash

./monitor.sh
DATA="./rezultate"


pause(){
    sleep 1;
}

while true; do
    clear
    echo "===== Package Monitor ====="
    echo "=-=-=-=-= Welcome =-=-=-=-="
    echo "1) Installed packages"
    echo "2) Newly installed packages"
    echo "3) Removed packages"
    echo "4) Exit"
    echo
    read -p "Choice: " c

    case "$c" in
        1) less "$DATA/installed_save.txt" ;;
        2) less "$DATA/latest.txt" ;;
        3) less "$DATA/deleted_save.txt" ;;
        4) exit 0;;
        *) echo "Invalid option"; sleep 1 ;;
    esac
done