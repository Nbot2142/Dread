#!/bin/bash

# Colors
GREEN='\033[0;32m'
WHITE='\033[1;37m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function show_banner() {
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Dread is active${NC}"
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Version: 1.0${NC}"
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Type 'drdhelp' to display available commands${NC}"
}

function drdhelp() {
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Available commands:${NC}"
    echo -e "${WHITE}  scannw - Scans the network and displays the IP addresses and names of devices${NC}"
    echo -e "${WHITE}  cnctip <IP> - Connects to the device with the specified IP address${NC}"
    echo -e "${WHITE}  uncnctip - Disconnects from the connected device${NC}"
    echo -e "${WHITE}  dvcinfo <IP> - Displays information about the device with the specified IP address${NC}"
    echo -e "${WHITE}  tsmsg <IP> - Sends a test message to the device with the specified IP address${NC}"
}

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

function cnctip() {
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Connecting to device with IP: $1${NC}"
    # Tutaj dodaj kod łączący się z urządzeniem o podanym IP
    # Przykład: ssh $1
}

function uncnctip() {
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Disconnecting from the connected device${NC}"
    # Tutaj dodaj kod odłączający się od aktualnie połączonego urządzenia
}

function dvcinfo() {
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Getting information for device with IP: $1${NC}"
    # Tutaj dodaj kod wyświetlający informacje o urządzeniu o podanym IP
}

function tsmsg() {
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Sending a test message to device with IP: $1${NC}"
    # Tutaj dodaj kod wysyłający testową wiadomość do urządzenia o podanym IP
}

# Główna pętla programu
while true; do
    show_banner

    read -p "[Dread] Enter a command: " command args

    case $command in
        drdhelp)
            drdhelp
            ;;
        scannw)
            scannw
            ;;
        cnctip)
            cnctip $args
            ;;
        uncnctip)
            uncnctip
            ;;
        dvcinfo)
            dvcinfo $args
            ;;
        tsmsg)
            tsmsg $args
            ;;
        *)
            echo -e "${WHITE}[${RED}Dread${WHITE}] Unknown command. Type 'drdhelp' to display available commands.${NC}"
            ;;
    esac

    echo # Pusta linia dla czytelności
done
