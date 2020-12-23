#!/usr/bin/env Rscript
#PBS -j oe
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -J 0-3

PBS_ARRAY_INDEX = Sys.getenv("PBS_ARRAY_INDEX", NA)
i = as.integer(PBS_ARRAY_INDEX) + 1L

message("PBS_ARRAY_INDEX: ", PBS_ARRAY_INDEX)
message("LETTERS[i]: ", LETTERS[i])
