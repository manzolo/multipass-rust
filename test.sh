#!/bin/bash

HOST_DIR_NAME=${PWD}
#Include functions
. $(dirname $0)/script/__functions.sh 

msg_warn "Test VM"
msg_warn "Shell on "$VM_NAME
msg_info "multipass shell "$VM_NAME
echo ""
msg_warn "#Run command on "$VM_NAME
command_on_vm="hostname"
command="multipass exec -v ${VM_NAME} -- ${command_on_vm}"
msg_warn "$command"
echo ""
$command
