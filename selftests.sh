#!/bin/bash

function run_device_selftest()
{
    ./submit_for_testing.py --variables variables.ini --device-type $1 --dry-run --test-case $2
    echo $?
}

exit_code=0
for BOARD_TYPE in ./devices/*
do
    for TEST in ./testcases/*.yaml
    do
        if [ -d $BOARD_TYPE ]
        then
            for NESTED_BOARD_TYPE in $BOARD_TYPE/*
            do
                device_exit_code=$(run_device_selftest $(basename $BOARD_TYPE)/$(basename $NESTED_BOARD_TYPE) $(basename $TEST))
                if [ $device_exit_code -gt $exit_code ]; then exit_code=$device_exit_code; fi
            done
        else
            device_exit_code=$(run_device_selftest $(basename $BOARD_TYPE) $(basename $TEST))
            if [ $device_exit_code -gt $exit_code ]; then exit_code=$device_exit_code; fi
        fi
    done
done
exit $exit_code
