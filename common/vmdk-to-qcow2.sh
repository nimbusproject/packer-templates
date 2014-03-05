#!/bin/sh

if [ $# -ne 2 ]; then
  echo "usage: $0 vmdk_image qcow2_image"
  exit 1
fi

qemu-img convert -O qcow2 "$1" "$2"
