#!/bin/bash

# L:Low M:Middle H:High
# 23: --> 2(re) + delay 3
# 12: --> 1(do) + delay 2
arr=(
    M 23 21 22 12 22 42 52 23 21 22 12 22 12 L 62 M 12
    23 21 22 12 22 42 42 52 64 52 61 52 44 24 
    23 21 24 12 22 42 42 52 23 21 22 12 22 12 L 62 M 12
    23 21 22 12 22 42 42 52 64 52 61 51 44 24
    44 34 24 14 12 11 21 L 62 52 64 64 62 M 12 24 54 34
    43 41 32 12 24 24 44 34 24 14 12 11 21 L 62 52 64 62 M 12
    22 24 22 44 54 34 34 34 34 22 42 53 53 62 66 62
    H 12 22 M 52 42 64 22 42 53 53 62 63 62 62 62 52 42 44 22 42
    53 53 62 63 62 H 12 22 M 52 42 64 22 42 64 64 54 44
    52 62 32 12 24 
 )

current_tone=""

multiplier=$1

for value in "${arr[@]}"; do
    if [[ "$value" =~ ^(L|M|H)$ ]]; then
        current_tone="$value"
        continue
    fi
    
    ten=$((value / 10))

    echo "Now: $current_tone $ten"

    case $current_tone in
        L)
            printf "D\x14" > /dev/$2
            ;;
        M)
            printf "D\x15" > /dev/$2
            ;;
        H)
            printf "D\x16" > /dev/$2
            ;;
        *)
            echo "error"
            continue
            ;;
    esac
    

    unit=$((value % 10))
    total_delay=$((unit * multiplier))
    
    # delay
    printf "Y\x0$ten" > /dev/$2
    echo "delay $total_delay ms"
    sleep $(echo "scale=3; $total_delay / 1000" | bc) 
done