#!/bin/bash

HOST_DIR_NAME=${PWD}

#Include functions
. $(dirname $0)/script/__functions.sh 
. $(dirname $0)/script/_hosts_manager.sh 

VM_STATUS=$(multipass info $VM_NAME | grep State | awk '{print $2}')

case $VM_STATUS in
    "Running")
        msg_warn "Stop vm..."
        multipass unmount $VM_NAME:"$HOST_DIR_NAME/.cargo" >/dev/null 2>&1
        multipass unmount $VM_NAME:"$HOST_DIR_NAME/src" >/dev/null 2>&1
        multipass stop $VM_NAME
        removehost
        ;;
    "Restarting")
        n=0
        until [ ${n} -ge ${RETRY_COMMAND:-5} ]
        do
            VM_STATUS=$(multipass info $VM_NAME | grep State | awk '{print $2}')
            if [[ $VM_STATUS =~ "Restarting" ]]; then
                msg_warn "$VM_NAME restarting..."
                break
            elif [[ $VM_STATUS =~ "Running" ]]; then
                msg_warn "Stop vm..."
                multipass stop $VM_NAME
                removehost
                msg_info "$VM_NAME stopped!"
                break
            fi           
            n=$((n+1)) 
            sleep ${SLEEP_RETRY:-10}
        done
        ;;
    "Starting")
        n=0
        until [ ${n} -ge ${RETRY_COMMAND:-5} ]
        do
            VM_STATUS=$(multipass info $VM_NAME | grep State | awk '{print $2}')
            if [[ $VM_STATUS =~ "Running" ]]; then
                msg_warn "Stop vm..."
                multipass stop $VM_NAME
                removehost
                msg_info "$VM_NAME stopped!"
                break
            elif [[ $VM_STATUS =~ "Restarting" ]]; then
                msg_warn "$VM_NAME restarting..."
            fi
            n=$((n+1)) 
            sleep ${SLEEP_RETRY:-10}
        done
        ;;
    "Stopped")
        msg_info "$VM_NAME already stopped"
        ;;
    *) 
        msg_error "$VM_NAME: $VM_STATUS"
        ;;
esac

