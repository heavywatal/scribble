#!/bin/bash
#PBS -S /bin/bash
#PBS -N envvars.sh
#PBS -j oe
#PBS -l select=1:ncpus=1:mem=1gb
date -Iseconds
echo "$(hostname):$(pwd)"
cd $PBS_O_WORKDIR
pwd

echo "PBS_DEFAULT: $PBS_DEFAULT"
echo "PBS_DPREFIX: $PBS_DPREFIX"
echo "PBS_ENVIRONMENT: $PBS_ENVIRONMENT"
echo "PBS_JOBDIR: $PBS_JOBDIR"
echo "PBS_JOBID: $PBS_JOBID"
echo "PBS_JOBNAME: $PBS_JOBNAME"
echo "PBS_NODEFILE: $PBS_NODEFILE"
echo "PBS_O_HOME: $PBS_O_HOME"
echo "PBS_O_HOST: $PBS_O_HOST"
echo "PBS_O_LANG: $PBS_O_LANG"
echo "PBS_O_LOGNAME: $PBS_O_LOGNAME"
echo "PBS_O_MAIL: $PBS_O_MAIL"
echo "PBS_O_PATH: $PBS_O_PATH"
echo "PBS_O_QUEUE: $PBS_O_QUEUE"
echo "PBS_O_SHELL: $PBS_O_SHELL"
echo "PBS_O_SYSTEM: $PBS_O_SYSTEM"
echo "PBS_O_TZ: $PBS_O_TZ"
echo "PBS_O_WORKDIR: $PBS_O_WORKDIR"
echo "PBS_QUEUE: $PBS_QUEUE"
echo "PBS_TMPDIR: $PBS_TMPDIR"
echo "TMPDIR: $TMPDIR"

date -Iseconds
