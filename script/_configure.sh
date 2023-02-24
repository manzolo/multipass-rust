#!/bin/bash
HOST_DIR_NAME=$1
. $HOST_DIR_NAME/script/__functions.sh

for file in ${HOST_DIR_NAME}/install/prepare/*
do
    [ -f ${file} ] || continue
    msg_warn "Installing: $(basename $file)"
    chmod a+x ${file}
    ${file}
done

#Install packages here
sudo apt install -yqq build-essential
echo "Inntall Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
