#!/bin/bash

set -e

KAZU_APP_DIR=~/projects/kazu_app
PROTO_DIR=${KAZU_APP_DIR}/protobuf
INC_DIR=${KAZU_APP_DIR}/protobuf
OUTPUT_DIR=${KAZU_APP_DIR}/lib/generated

PROTO_FILES=$(ls ${PROTO_DIR}/*.proto)
PROTO_FILES+=" "
PROTO_FILES+=$(ls ${PROTO_DIR}/**/*proto)

if [ ! -d ${OUTPUT_DIR} ]; then
    echo "Creating output directory... ${OUTPUT_DIR}"
    mkdir ${OUTPUT_DIR}
fi

#compile proto files
protoc -I=${INC_DIR} \
    --dart_out=${OUTPUT_DIR} \
    ${PROTO_FILES}
