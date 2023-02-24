#!/bin/bash
HOST_DIR_NAME=$1
. $HOST_DIR_NAME/script/__functions.sh

for file in ${HOST_DIR_NAME}/install/post/*
do
    [ -f ${file} ] || continue
    msg_warn "Installing: $(basename $file)"
    chmod a+x ${file}
    ${file}
done
