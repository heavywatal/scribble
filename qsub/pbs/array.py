#!/usr/bin/env python3
#PBS -N array-ms-py
#PBS -j oe
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -J 0-3
import os
import pathlib
import subprocess
import numpy as np

script_dir = pathlib.Path(__file__).parent
print(f'{script_dir=}')
# /var/spool/pbs/mom_priv/jobs/

os.chdir(os.getenv('PBS_O_WORKDIR', '.'))
array_index = int(os.getenv('PBS_ARRAY_INDEX', '0'))
param_range = np.linspace(5.0, 6.5, 4)  # [5.0, 5.5, 6.0, 6.5]
theta = param_range[array_index]
cmd = 'ms 4 2 -t {}'.format(theta)
proc = subprocess.run(cmd.split(), stdout=subprocess.PIPE)
print(proc.stdout.decode(), end='')
