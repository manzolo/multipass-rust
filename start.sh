#!/bin/bash

HOST_DIR_NAME=${PWD}

#Include functions
. ${HOST_DIR_NAME}/script/__functions.sh 

msg_warn "Starting vm..."
VM_STATUS=$(multipass info $VM_NAME | grep State | awk '{print $2}')
case $VM_STATUS in
    "Running")
        msg_warn "$VM_NAME already running..."
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
                msg_info "$VM_NAME started!"
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
                msg_warn "$VM_NAME already running..."
                break
            elif [[ $VM_STATUS =~ "Starting" ]]; then
                msg_warn "$VM_NAME starting..."
            fi           
            n=$((n+1)) 
            sleep ${SLEEP_RETRY:-10}
        done
        ;;
    "Stopped")
        multipass start $VM_NAME
        msg_info "$VM_NAME started!"
        . ${HOST_DIR_NAME}/script/_hosts_manager.sh
        removehost
        addhost
        multipass mount "$HOST_DIR_NAME/src" "$VM_NAME:/src" >/dev/null 2>&1
        multipass mount "$HOST_DIR_NAME/.cargo" "$VM_NAME:/home/ubuntu/.cargo" >/dev/null 2>&1
        ;;
    *) 
        msg_error "$VM_NAME: $VM_STATUS"
        ;;
esac

while [ "`echo $1 | cut -c1`" = "-" ]
do
    case "$1" in
        -v)
            echo "------------------------------------------------"
            echo ""
            msg_warn "Shell on "$VM_NAME
            msg_info "multipass shell "$VM_NAME
            echo ""
            echo "Useful commands"
            msg_info "cargo run"
            msg_info "cargo build --release"
            echo ""
            echo ""
            echo "Start VM:"
            msg_warn "./start.sh"
            echo "Stop VM:"
            msg_warn "./stop.sh"
            echo "Uninstall VM:"
            msg_warn "./uninstall.sh"
            echo "------------------------------------------------"
            shift 1
            ;;
        *)
            exit 1
            ;;
esac
done

