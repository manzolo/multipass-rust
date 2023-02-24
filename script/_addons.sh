#!/bin/bash
HOST_DIR_NAME=$1
. $HOST_DIR_NAME/script/__functions.sh

for PACKAGE in ${ADDONS[@]}; do
  msg_warn "Install $PACKAGE"
  wget https://raw.githubusercontent.com/manzolo/multipass-addon-${PACKAGE}/main/install.sh -q -O - | sh 
done

sed -i '$a\source "$HOME/.cargo/env"' ~/.zshrc
sed -i '$a\source "$HOME/.cargo/env"' ~/.bashrc
