#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G

date -Iseconds
echo "$(hostname):$(pwd)"
echo "PATH: $PATH"

echo "Hello, Slurm!"
echo "=================================="
echo "SLURMD_NODENAME: $SLURMD_NODENAME"
echo "SLURM_SUBMIT_DIR: $SLURM_SUBMIT_DIR"
echo "SLURM_JOB_ID: $SLURM_JOB_ID"
echo "SLURM_JOB_NAME: $SLURM_JOB_NAME"
echo "SLURM_JOB_START_TIME: $SLURM_JOB_START_TIME"
echo "SLURM_JOB_END_TIME: $SLURM_JOB_END_TIME"
echo "SLURM_JOB_CPUS_PER_NODE: $SLURM_JOB_CPUS_PER_NODE"
echo "SLURM_CPUS_PER_TASK: $SLURM_CPUS_PER_TASK"
echo "SLURM_MEM_PER_CPU: $SLURM_MEM_PER_CPU"
echo "SLURM_MEM_PER_NODE: $SLURM_MEM_PER_NODE"
echo "=================================="

set -eu

REPEATMASKER_LIBS="/home/local/RepeatMasker/Libraries"
PREFIX="/home/local/db/dfam.org"
VER_MAJOR="3"
VER_MINOR="9"
RELPATH="releases/Dfam_${VER_MAJOR}.${VER_MINOR}/families/FamDB"

set -x

mkdir -p "${REPEATMASKER_LIBS}/famdb"
unzstd -k "${PREFIX}/${RELPATH}"/dfam*.h5.gz
mv "${PREFIX}/${RELPATH}"/dfam*.h5 "${REPEATMASKER_LIBS}/famdb"

date -Iseconds
