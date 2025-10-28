#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G

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

if [ -e "${REPEATMASKER_LIBS:=/home/local/RepeatMasker/Libraries}" ]; then
  echo "REPEATMASKER_LIBS: $REPEATMASKER_LIBS"
else
  echo "ERROR: REPEATMASKER_LIBS not found: $REPEATMASKER_LIBS" >&2
  exit 1
fi
IMG="/home/antares/sif/images/dfam-tetools_1.94.sif"

set -x

rm "${REPEATMASKER_LIBS}/famdb/rmlib.config"

apptainer run \
 --mount type=bind,src="$REPEATMASKER_LIBS",dst=/opt/RepeatMasker/Libraries \
 --cwd /opt/RepeatMasker \
 "$IMG" ./tetoolsDfamUpdate.pl

date -Iseconds
