#!/bin/bash

#$ -S /bin/bash
#$ -l short
#$ -cwd

echo "pwd: $(pwd)"
echo "Rscript start"
Rscript envvars.R
echo "Rscript end"
