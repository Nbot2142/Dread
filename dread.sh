#!/bin/bash

# Kolorowe oznaczenia
WHITE='\033[1;37m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # Bez koloru

# Funkcja pobierająca nazwę urządzenia na podstawie adresu IP
function get_device_name() {
    local ip="$1"
    local name=""

    # Sprawdzanie nazwy urządzenia za pomocą nslookup
    name=$(nslookup "$ip" | awk -F'= ' '/name =/{print $2}' | awk '{print $1}')

    echo "$name"
}

# Komenda scannw - skanowanie sieci i wyświetlanie adresów IP i nazw urządzeń
function scannw() {
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Scanning the network...${NC}"
    
    # Pobieranie listy dostępnych interfejsów sieciowych
    interfaces=$(ip -o link show | awk -F': ' '{print $2}')

    # Iteracja przez wszystkie interfejsy i skanowanie sieci
    for interface in $interfaces; do
        echo -e "${WHITE}[${GREEN}Dread${WHITE}] Scanning network on interface: ${interface}${NC}"
        sudo arp-scan --localnet --interface "$interface"
        echo -e "${WHITE}[${GREEN}Dread${WHITE}] Network scanning on interface ${interface} completed.${NC}"
        echo # Pusta linia dla czytelności
    done
}

# Komenda dvcinfo - wyświetlanie informacji o urządzeniu na podstawie adresu IP
function dvcinfo() {
    local ip="$1"

    if [[ -z "$ip" ]]; then
        echo -e "${WHITE}[${RED}Dread${WHITE}] No IP address provided.${NC}"
        return
    fi

    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Device Information:${NC}"
    echo -e "IP Address: ${ip}"
    echo -e "Device Name: $(get_device_name "$ip")"
    echo # Pusta linia dla czytelności
}

# Komenda cnctip - połączenie z urządzeniem na podstawie adresu IP
function cnctip() {
    local ip="$1"

    if [[ -z "$ip" ]]; then
        echo -e "${WHITE}[${RED}Dread${WHITE}] No IP address provided.${NC}"
        return
    fi

    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Connecting to device at IP address: ${ip}${NC}"
    # Tutaj możesz umieścić kod odpowiedzialny za nawiązanie połączenia z urządzeniem o podanym adresie IP
}

# Komenda tsmsg - wysłanie testowej wiadomości na urządzenie na podstawie adresu IP
function tsmsg() {
    local ip="$1"
    local message="$2"

    if [[ -z "$ip" ]]; then
        echo -e "${WHITE}[${RED}Dread${WHITE}] No IP address provided.${NC}"
        return
    fi

    if [[ -z "$message" ]]; then
        echo -e "${WHITE}[${RED}Dread${WHITE}] No message provided.${NC}"
        return
    fi

    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Sending test message to device at IP address: ${ip}${NC}"
    # Tutaj możesz umieścić kod odpowiedzialny za wysłanie testowej wiadomości do urządzenia o podanym adresie IP
}

# Wyświetlanie informacji o Dread po uruchomieniu
echo -e "${WHITE}[${GREEN}Dread${WHITE}] Dread is active${NC}"
echo -e "${WHITE}[${GREEN}Dread${WHITE}] Version: 1.0${NC}"
echo -e "${WHITE}[${GREEN}Dread${WHITE}] Type 'drdhelp' to display available commands${NC}"

# Pętla główna programu
while true; do
    read -p "${WHITE}[${GREEN}Dread${WHITE}] Enter a command: ${NC}" command

    case $command in
        "drdhelp")
            echo -e "Available commands:"
            echo -e "  ${GREEN}scannw${NC} - Scans the network and displays the IP addresses of devices along with their names."
            echo -e "  ${GREEN}dvcinfo <IP>${NC} - Displays information about the device with the specified IP address."
            echo -e "  ${GREEN}cnctip <IP>${NC} - Connects to the device with the specified IP address."
            echo -e "  ${GREEN}tsmsg <IP> <message>${NC} - Sends a test message to the device with the specified IP address."
            ;;
        "scannw")
            scannw
            ;;
        "dvcinfo "*)
            ip="${command#* }"
            dvcinfo "$ip"
            ;;
        "cnctip "*)
            ip="${command#* }"
            cnctip "$ip"
            ;;
        "tsmsg "*)
            ip="${command#* }"
            message="${ip#* }"
            ip="${ip%% *}"
            tsmsg "$ip" "$message"
            ;;
        *)
            echo -e "${WHITE}[${RED}Dread${WHITE}] Unknown command.${NC}"
            ;;
    esac
done
