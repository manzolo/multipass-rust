#!/bin/bash

#Include functions
source $(dirname $0)/script/__functions.sh

msg_warn "== Stop vm"
$(dirname $0)/stop.sh

msg_warn "== Clean vm"

echo "remove $VM_NAME"
multipass delete $VM_NAME
multipass purge
multipass list

msg_info "== Vm clear"
