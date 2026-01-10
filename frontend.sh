#!/bin/bash

./monitor.sh monitor
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
    echo "4) History of a package"
    echo "5) Changes made in a time interval"
    echo "6) Exit"
    echo
    read -p "Please input the number of the choice: " c

    case "$c" in
        1) 
            less "$DATA/installed_save.txt" ;;
        2) 
            less "$DATA/latest.txt" ;;
        3) 
            less "$DATA/deleted_save.txt" ;;
        4)
            echo "===== Package Monitor ====="
            read -p "Please write the name of the packing you are looking for: "  pk
            ./monitor.sh package_history "$pk" | less  
            ;;
        5)
            echo "===== Package Monitor ====="
            
            read -p "Please write the beginning date: " interval
	    read -p "Please wtite the end date: " interval2
            ./monitor.sh search_interval "$interval" "$interval2" | less
            ;;
        6) 
            exit 0;;
        *) 
            echo "Invalid option"; pause;;
    esac
done
