#!/usr/bin/env Rscript

#$ -S /usr/bin/Rscript
#$ -l short
#$ -cwd

args = commandArgs(trailingOnly = TRUE)

script = args[1L]
JOB_ID = Sys.getenv("JOB_ID", NA)
message("JOB_ID:", JOB_ID)
message("getwd():", getwd())
message("source('", script, "') ##########")
source(script, echo = FALSE)
message("##########")
message("uge.R ends")
