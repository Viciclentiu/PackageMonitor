#!/bin/bash

#Se vor crea fisierele destinatie
log="/var/log/dpkg.log"

#TODO:
package_history(){
    hist=$(grep "$1" "$log" | sort -u)
    echo "$hist"
}

#TODO:
#interval de timp
#search_interval(){
#
#}
#

monitor(){
    #dest_f = "$(cd -- "$(dirname -- "$0")" && pwd)" - mereu in directorul PackageMonitor
    #dest_f="./rezultate" o sa-l creeze in pwd
    script_dir="$(cd -- "$(dirname -- "$0")" && pwd)"
    dest_f="$script_dir/rezultate"
    installed_save="$dest_f/installed_save.txt"
    latest="$dest_f/latest.txt"
    deleted_save="$dest_f/deleted_save.txt"
    mkdir -p "$dest_f"
    #cauta pachetele deja instalate fara datele de instalare
    # actual=$(grep " status installed " "$log" | awk '{print $4}' | cut -d: -f1 | sort -u)
    actual=$(grep " status installed " "$log" | sort -u)

    deleted=$(grep " remove " "$log")
    tmp=$(grep " deinstall " "$log")
    deleted+=$tmp
    tmp=$(grep " purge " "$log")
    deleted+=$tmp
    deleted=$(echo "$deleted" | sort)

    #da start la monitor
    if [ ! -f "$installed_save" ]; then
        ./setup_crontab.sh
        echo "$actual" > "$installed_save"
        echo "$deleted" > "$deleted_save"
        echo "[Monitorizare activa la: $(date)]" >> "$latest"
    #cauta pachete instalate recent sau nu
    else
        echo "$actual" > "$dest_f/temp.txt"
        echo "$deleted" > "$dest_f/temp_del.txt"
        #curent minus installed_save (pachete instalate)
        new=$(grep -Fvxf "$installed_save" "$dest_f/temp.txt")
        
        new_del=$(grep -Fvxf "$deleted_save" "$dest_f/temp_del.txt")

        if [[ -z "$new" && -z "$new_del" ]]; then
            echo "[$(date)] Nu s-a efectuat nicio schimbare." >> "$latest"
        else
            #todo diferentiere elim si adaugat
            package_number=$(echo "$new" | wc -l)
            package_number_del=$(echo "$new_del" | wc -l)
            echo -e "\n[$(date)] $package_number pachete noi detectate:" >> "$latest"
            echo "$new" >> "$latest"
            echo "-----------" >> "$latest"
            echo -e "\n[$(date)] $package_number_del pachete eliminate:" >> "$latest"
            echo "$new_del" >> "$latest"
            echo "-----------" >> "$latest"

            mv "$dest_f/temp_del.txt" "$deleted_save" 
            rm "$dest_f/temp_del.txt"
            mv "$dest_f/temp.txt" "$installed_save"
            rm "$dest_f/temp.txt"     
        fi
        rm "$dest_f/temp_del.txt"
        rm "$dest_f/temp.txt"
    fi 
}

case "$1" in
    monitor)
        shift
        monitor
        ;;
    
    package_history)
        shift
        package_history "$@"
        ;;
    search_interval)
        shift 
        search_interval "$@"
        ;;
    *)  
        if [ $# -eq 0 ]; then
            echo "Error: No parameters provided"
        else
            echo "Error: Unknown command: $1"
        fi
        exit 1
        ;;
esac
exit 0

