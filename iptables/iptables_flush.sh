#!/bin/bash
#this script flushes the iptables to the specified policy (ACCEPT or DROP)
IPTABLES=/sbin/iptables
POLICY='' # policy setting
POLICIES=( ACCEPT,DROP ) # possible policies to operate with

function CheckForPolicy(){
    #if there's anything matching the array return 1
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match"]] && return 0; done
    return 1
}

function Flush(){
    ### flush existing rules and set chain policy settings
    echo "[+] Flushing existing iptables rules..."
    $IPTABLES -F
    $IPTABLES -F -t nat
    $IPTABLES -X
    $IPTABLES -P INPUT $POLICY
    $IPTABLES -P OUTPUT $POLICY
    $IPTABLES -P FORWARD $POLICY
}

function CheckInput(){

    if [[ -z "$1" ]]; then #if input is empty
        echo "No policy is specified. Accept policy is chosen for iptables flush."
        $POLICY='ACCEPT'
    else #if something is in the input, check it for the keywords in array
        if [[ CheckForPolicy "$1" "${POLICIES[@]}" == 1 ]]; then
            $POLICY=$1
            Flush
        else
            echo "Wrong policy. Try again."
        fi
    fi
}

CheckInput $1
