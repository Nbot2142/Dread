#!/bin/bash

# Ustawienie kolorów
GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[1;37m'
NC='\033[0m' # Resetowanie koloru

# Funkcja skanująca sieć i wyświetlająca adresy IP i nazwy urządzeń
function scannw() {
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Scanning the network...${NC}"
    
    # Przeskanowanie sieci i zapisanie wyników do pliku tymczasowego
    nmap -sn $network_address/24 | grep "Nmap scan report" > devices.txt
    
    # Wyświetlenie wyników skanowania
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Devices found:${NC}"
    while read -r line; do
        ip=$(echo $line | awk '{print $NF}')
        hostname=$(host $ip | awk '{print $NF}')
        echo -e "${WHITE}[${GREEN}Dread${WHITE}] IP: ${GREEN}$ip${WHITE}, Hostname: ${GREEN}$hostname${NC}"
    done < devices.txt
    
    # Usunięcie pliku tymczasowego
    rm devices.txt
}

# Funkcja nawiązująca połączenie z urządzeniem przez adres IP
function cnctip() {
    ip=$1
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Connecting to ${GREEN}$ip${NC}"
    
    # Sprawdzenie, czy jest połączenie z urządzeniem o podanym adresie IP
    if ping -c 1 $ip &> /dev/null; then
        # Nawiązanie połączenia SSH z urządzeniem o podanym adresie IP
        ssh $ip
    else
        echo -e "${WHITE}[${RED}Dread${WHITE}] Unable to connect to ${RED}$ip${NC}"
    fi
}

# Komenda odłączająca się od urządzenia
function uncnctip() {
    echo -e "${WHITE}[${RED}Dread${WHITE}] Disconnecting from the device${NC}"
    # Dodaj tutaj kod do odłączania się od urządzenia
}

# Komenda wysyłająca testową wiadomość
function tsmsg() {
    ip=$1
    echo -e "${WHITE}[${GREEN}Dread${WHITE}] Sending test message to ${GREEN}$ip${NC}"
    
    # Sprawdzenie, jaki jest system na podstawie adresu IP
    response=$(ssh $ip uname -s)
    if [[ $response == *"Linux"* ]]; then
        # Jeśli system to Linux, wykonaj odpowiednie działania
        echo -e "${WHITE}[${GREEN}Dread${WHITE}] Linux system detected${NC}"
        
        # Wykonanie polecenia na zdalnym systemie Linux (np. wysłanie messageboxa)
        ssh $ip 'zenity --info --text "This is a test message"'
        
        # Wyświetlenie komunikatu o wykonanej akcji
        echo -e "${WHITE}[${GREEN}Dread${WHITE}] Test message sent to ${GREEN}$ip${NC}"
    elif [[ $response == *"Windows"* ]]; then
        # Jeśli system to Windows, wykonaj odpowiednie działania
        echo -e "${WHITE}[${GREEN}Dread${WHITE}] Windows system detected${NC}"
        
        # Wykonanie polecenia na zdalnym systemie Windows (np. wysłanie messageboxa)
        ssh $ip 'cmd /c echo MsgBox "This is a test message" > test.vbs && cscript //B test.vbs'
        
        # Wyświetlenie komunikatu o wykonanej akcji
        echo -e "${WHITE}[${GREEN}Dread${WHITE}] Test message sent to ${GREEN}$ip${NC}"
    else
        echo -e "${WHITE}[${RED}Dread${WHITE}] Unknown system detected${NC}"
    fi
}

# Wyświetlanie napisu w odpowiednich kolorach
echo -e "${WHITE}[${GREEN}Dread${WHITE}] Dread is active${NC}"
echo -e "${WHITE}[${GREEN}Dread${WHITE}] Version: 1.0${NC}"
echo -e "${WHITE}[${GREEN}Dread${WHITE}] Type 'help' to display available commands${NC}"

# Obsługa komend
case $1 in
    help)
        echo -e "${WHITE}[${GREEN}Dread${WHITE}] Available commands:${NC}"
        echo -e "${WHITE}  help - Displays available commands${NC}"
        echo -e "${WHITE}  scannw - Scans the network and displays the IP addresses of devices${NC}"
        echo -e "${WHITE}  cnctip <IP> - Connects to the device with the specified IP address${NC}"
        echo -e "${WHITE}  uncnctip - Disconnects from the connected device${NC}"
        echo -e "${WHITE}  dvcinfo <IP> - Displays information about the specified device${NC}"
        echo -e "${WHITE}  tsmsg <IP> - Sends a test message to the specified device${NC}"
        ;;
    scannw)
        # Wywołanie funkcji skanującej sieć
        scannw
        ;;
    cnctip)
        # Wywołanie funkcji nawiązującej połączenie z podanym adresem IP
        cnctip "$2"
        ;;
    uncnctip)
        # Wywołanie funkcji odłączającej się od urządzenia
        uncnctip
        ;;
    dvcinfo)
        # Wywołanie funkcji wyświetlającej informacje o urządzeniu o podanym adresie IP
        dvcinfo "$2"
        ;;
    tsmsg)
        # Wywołanie funkcji wysyłającej testową wiadomość
        tsmsg "$2"
        ;;
    *)
        echo -e "${WHITE}[${RED}Dread${WHITE}] Unknown command${NC}"
        ;;
esac
