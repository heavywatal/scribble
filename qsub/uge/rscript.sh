#!/bin/bash
#$ -S /bin/bash
#$ -l short
#$ -cwd

echo "pwd: $(pwd)"
module load r/3.5.2
echo "Rscript start"
Rscript envvars.R
echo "Rscript end"
