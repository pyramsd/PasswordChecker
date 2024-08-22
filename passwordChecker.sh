#!/bin/bash

help(){
    echo "Usage: ./passwordChecker.sh <password> [-wordlist <ruta_a_wordlist>]"
    echo
    echo "Parameters:"
    echo "    password        Contraseña a evaluar"
    echo "    -wordlist       Lista de contraseñas en un archivo"
}

if [ "$#" -eq 0 ]; then
    help
    exit 1
fi

password="$1"
wordlist=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        (-wordlist) wordlist="$2"; shift ;;
        (*) password="$1" ;;
    esac
    shift
done

score=$(echo "$password" | zxcvbn | jq '.score')
suggestions=$(echo "$password" | zxcvbn | jq -r '.feedback.suggestions[]')
sequence=$(echo "$password" | zxcvbn | jq -r '.sequence[].token')
display_online_throttling_100_per_hour=$(echo "$password" | zxcvbn | jq '.crack_times_display.online_throttling_100_per_hour')
display_online_no_throttling_10_per_second=$(echo "$password" | zxcvbn | jq '.crack_times_display.online_no_throttling_10_per_second')
display_offline_slow_hashing_1e4_per_second=$(echo "$password" | zxcvbn | jq '.crack_times_display.offline_slow_hashing_1e4_per_second')
display_offline_fast_hashing_1e10_per_second=$(echo "$password" | zxcvbn | jq '.crack_times_display.offline_fast_hashing_1e10_per_second')

echo Score: $score
echo Suggestions: $suggestions
echo Sequences: $sequence
echo "crack times display:"
echo "    100 intentos por hora: $display_online_throttling_100_per_hour"
echo "    10 intentos por segundo: $display_online_no_throttling_10_per_second"
echo "    Hashing 1e4 por segundo lento: $display_offline_slow_hashing_1e4_per_second"
echo "    Hashing 1e10 por segundo rápido: $display_offline_fast_hashing_1e10_per_second"

if [ -n "$wordlist" ]; then
    extension="${wordlist##*.}"

    if [ "$extension" = "$wordlist" ] || [ -z "$extension" ]; then
        extension="txt"
    fi

    case "$extension" in
        ("gz")
            command=$(zcat "$wordlist" | grep -wo "$password")
            ;;
        ("zip")
            command=$(unzip -p "$wordlist" | grep -wo "$password")
            ;;
        ("txt")
            command=$(cat "$wordlist" | grep -wo "$password")
            ;;
        (*)
            echo "Extensión de archivo no soportada: $extension"
            exit 1
            ;;
    esac

    if [ -n "$command" ]; then
        echo -e "\e[31m\n[-] La contraseña -> $password <- ha sido filtrada\e[0m"
    else
        echo -e "\e[32m\n[+] La contraseña -> $password <- no ha sido filtrada\e[0m"
    fi

    echo "La extensión del archivo de wordlist es: $extension"
    exit 1
fi
