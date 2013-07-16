#!/bin/sh

if [ $# -ne 2 ]; then
  echo "usage: $0 vmdk_image raw_image"
  exit 1
fi

qemu-img convert -O raw "$1" "$2"
dd if="$2" bs=512 skip=63 | gzip > "$2.gz"
rm -f "$2"
