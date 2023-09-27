#!/bin/bash
#PBS -S /bin/bash
#PBS -N array-ms
#PBS -j oe
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -J 0-3
date -Iseconds
hostname
cd $PBS_O_WORKDIR
pwd

cd $PBS_O_WORKDIR
param_range=($(seq 5.0 0.5 6.5))  # (5.0, 5.5, 6.0, 6.5)
theta=${param_range[@]:${PBS_ARRAY_INDEX}:1}
ms 4 2 -t $theta

date -Iseconds
