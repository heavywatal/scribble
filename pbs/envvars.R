#!/usr/bin/env Rscript
#PBS -N envvars.R
#PBS -j oe
#PBS -l select=1:ncpus=6:mem=6gb
options(mc.cores = 6L)

message("PBS_DEFAULT: ", Sys.getenv("PBS_DEFAULT"))
message("PBS_DPREFIX: ", Sys.getenv("PBS_DPREFIX"))
message("PBS_ENVIRONMENT: ", Sys.getenv("PBS_ENVIRONMENT"))
message("PBS_JOBDIR: ", Sys.getenv("PBS_JOBDIR"))
message("PBS_JOBID: ", Sys.getenv("PBS_JOBID"))
message("PBS_JOBNAME: ", Sys.getenv("PBS_JOBNAME"))
message("PBS_NODEFILE: ", Sys.getenv("PBS_NODEFILE"))
message("PBS_O_HOME: ", Sys.getenv("PBS_O_HOME"))
message("PBS_O_HOST: ", Sys.getenv("PBS_O_HOST"))
message("PBS_O_LANG: ", Sys.getenv("PBS_O_LANG"))
message("PBS_O_LOGNAME: ", Sys.getenv("PBS_O_LOGNAME"))
message("PBS_O_MAIL: ", Sys.getenv("PBS_O_MAIL"))
message("PBS_O_PATH: ", Sys.getenv("PBS_O_PATH"))
message("PBS_O_QUEUE: ", Sys.getenv("PBS_O_QUEUE"))
message("PBS_O_SHELL: ", Sys.getenv("PBS_O_SHELL"))
message("PBS_O_SYSTEM: ", Sys.getenv("PBS_O_SYSTEM"))
message("PBS_O_TZ: ", Sys.getenv("PBS_O_TZ"))
message("PBS_O_WORKDIR: ", Sys.getenv("PBS_O_WORKDIR"))
message("PBS_QUEUE: ", Sys.getenv("PBS_QUEUE"))
message("PBS_TMPDIR: ", Sys.getenv("PBS_TMPDIR"))
message("TMPDIR: ", Sys.getenv("TMPDIR"))

sessionInfo()

setwd(Sys.getenv("PBS_O_WORKDIR"))
message("getwd(): ", getwd())

print(.libPaths())
message(".Library: ", .Library)
message(".Library.site: ", .Library.site)
message("Sys.timezone(): ", Sys.timezone())

print(Sys.time())
.devnull = parallel::mclapply(seq_len(getOption("mc.cores")), function(x) {Sys.sleep(5)})
print(Sys.time())
