#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --array=1-3

date -Iseconds
echo "$(hostname):$(pwd)"
echo "PATH: $PATH"

echo "Hello, Slurm job array!"
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
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_TASK_COUNT: $SLURM_ARRAY_TASK_COUNT"
echo "=================================="

PARAM_ARRAY=(alpha beta gamma)
PARAM=${PARAM_ARRAY[$SLURM_ARRAY_TASK_ID]}
echo "PARAM: $PARAM"
# do something with "$PARAM"

PADDED_ID=$(printf "%03d" $SLURM_ARRAY_TASK_ID)
INPUT_FILE="data_${PADDED_ID}.txt"
echo "INPUT_FILE: $INPUT_FILE"
# do something with "$INPUT_FILE"

# just for demonstration; try `scontrol show job` etc.
sleep 60

date -Iseconds
