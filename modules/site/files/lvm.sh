#!/bin/sh

set -e

VGNAME=cinder-volumes
IMGFILE=/lvm.img
IMGSIZE='bs=1G seek=4'
LOOPDEV=/dev/loop0

if ! vgs $VGNAME >/dev/null 2>&1
then
  if ! losetup $LOOPDEV >/dev/null 2>&1
  then
    if [ ! -f $IMGFILE ]
    then
      dd if=/dev/null of=$IMGFILE $IMGSIZE
      losetup $LOOPDEV $IMGFILE
      echo ,,8e,, | sfdisk $LOOPDEV
      pvcreate $LOOPDEV
      vgcreate $VGNAME $LOOPDEV
    else
      losetup $LOOPDEV $IMGFILE
      vgscan
    fi
  fi
fi
