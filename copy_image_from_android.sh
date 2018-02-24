#!/bin/bash

cd /home/bbn/pictrues/max2
adb shell 'ls /sdcard/DCIM/Camera/IMG_201802*' | tr -d '\r' | xargs -n1 adb pull
adb shell 'ls /sdcard/DCIM/Camera/VID_201802*' | tr -d '\r' | xargs -n1 adb pull
