#!/bin/sh
#PBS -N sleep.sh
#PBS -j oe
#PBS -l select=1:ncpus=1:mem=1gb
echo "pwd: $(pwd)"
env | grep PBS
TIME=${1:-3}
echo "sleep $TIME"
date
sleep $TIME
date
