#!/bin/bash
currenttime=$(date +%H:%M)
if [[ "$currenttime" > "22:30" ]] || [[ "$currenttime" < "10:00" ]]; then
	sudo pkill -9 python
	set -x
	set -e
	python /home/pi/WORKSPACE/RaspiMotionAlarmRewrite/py_scripts/motion_simple_rewrite_fixed.py
else
	echo "Not Inside Time Window"
fi