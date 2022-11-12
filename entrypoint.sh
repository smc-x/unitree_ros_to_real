#!/bin/bash
if $(cat /etc/hosts | grep $(hostname)); then
    # hostname already added
    echo "hostname added"
else
    echo "127.0.0.1 $(hostname)" >> /etc/hosts
    echo "hostname added"
fi

. /root/catkin_ws/devel/setup.bash
roslaunch unitree_legged_real real.launch ctrl_level:=highlevel &
PID1=$!

if [ -z $@ ]; then
    CMD="sleep infinity"
else
    CMD=$@
fi
bash -c "${CMD}" &
PID2=$!

# wait for any subprocess that exits first
wait -n
kill -9 ${PID2}
kill -9 ${PID1}
exit -1
