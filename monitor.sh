#!/bin/bash
#Se vor crea fisierele destinatie
log="/var/log/dpkg.log"  
dest_f="$HOME/rezultate"
last_check="$dest_f/last_check.txt"
newest="$dest_f/newest.txt"
mkdir -p "$dest_f"
#cauta pachetele deja instalate fara datele de instalare
# actual=$(grep " status installed " "$log" | awk '{print $4}' | cut -d: -f1 | sort -u)
actual=$(grep " status installed " "$log" | sort -u)

#da start la monitor
if [ ! -f "$last_check" ]; then
    echo "$actual" > "$last_check"
    echo "[Monitorizare activa la: $(date)]" >> "$newest"
#cauta pachete instalate recent sau nu
else
    echo "$actual" > "$dest_f/temp.txt"
    #comm compara fisierele si nou retine ce e in temp.txt, dar nu in last_check.txt
    nou=$(grep -Fvxf "$last_check" "$dest_f/temp.txt")./
    if [[ -z "$nou" ]]; then
        echo "[$(date)] Nu s-a efectuat nicio schimbare." >> "$newest"
    else
        nr_pachete=$(echo "$nou" | wc -l)
        echo -e "\n[$(date)] $nr_pachete pachete noi detectate:" >> "$newest"
        echo "$nou" >> "$newest"
        mv "$dest_f/temp.txt" "$last_check"
    fi
fi 
exit 0

