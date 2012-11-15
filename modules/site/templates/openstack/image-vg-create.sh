#!/bin/sh

set -e

VGNAME=<%= vgname %>
LOOP_DEVICE=<%= loop_device %>
IMAGE_FILE=<%= image_file %>
IMAGE_SIZE='bs=1k seek=<%=
  if image_size =~ /^(\d+)\s*([GMK])$/
    count = $1.to_i
    unit = $2
    factor = { "K" => 1, "M" => 1024, "G" => 1048576 }[unit]
    fail "Invalid unit: #{unit}" unless factor
    count * factor
  else
    fail "Invalid image_size format: #{image_size}"
  end
%>'

if ! vgs $VGNAME >/dev/null 2>&1
then
  if ! losetup $LOOP_DEVICE >/dev/null 2>&1
  then
    if [ ! -f $IMAGE_FILE ]
    then
      dd if=/dev/null of=$IMAGE_FILE $IMAGE_SIZE
      losetup $LOOP_DEVICE $IMAGE_FILE
      echo ,,8e,, | sfdisk $LOOP_DEVICE
      pvcreate $LOOP_DEVICE
      vgcreate $VGNAME $LOOP_DEVICE
    else
      losetup $LOOP_DEVICE $IMAGE_FILE
      vgscan
    fi
  fi
fi

if service cinder-volume status | grep -q stop; then
  service cinder-volume start
fi
