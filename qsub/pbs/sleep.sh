#!/bin/bash
#PBS -S /bin/bash
#PBS -N sleep.sh
#PBS -j oe
#PBS -l select=1:ncpus=1:mem=1gb
date -Iseconds
hostname
cd $PBS_O_WORKDIR
pwd
env | grep PBS

TIME=${1:-3}
echo "sleep $TIME"
date -Iseconds
sleep $TIME
date -Iseconds
