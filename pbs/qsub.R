#!/usr/bin/env Rscript
#PBS -N qsub.R
#PBS -j oe
#PBS -l select=1:ncpus=24:mem=24gb
#
# qsub.py -j24 -m24 -N jobname path/to/script.R
#
# qsub -v NCPUS=24,INFILE=sleep.R -N jobname qsub.R
# NCPUS=3 INFILE=envvars.R qsub.R
#
stopifnot(!is.na(Sys.getenv("INFILE", NA)))
script = Sys.getenv("INFILE", NA)
PBS_O_WORKDIR = Sys.getenv("PBS_O_WORKDIR", NA)
if (!is.na(PBS_O_WORKDIR)) {
  setwd(PBS_O_WORKDIR)
  options(mc.cores = Sys.getenv("NCPUS", 24L))
} else {
  # for testing
  options(mc.cores = Sys.getenv("NCPUS", 2L))
}
message("mc.cores:", getOption("mc.cores"))
message("getwd():", getwd())
message("source('", script, "') ##########")
source(script, echo = FALSE)
