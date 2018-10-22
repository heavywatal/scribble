#!/usr/bin/env Rscript
#PBS -N envvars.R
#PBS -j oe
#PBS -l select=1:ncpus=1:mem=1gb
sessionInfo()
message("Sys.timezone(): ", Sys.timezone())
message(".libPaths(): ", paste(.libPaths(), collapse = ":"))
message(".Library: ", .Library)
message(".Library.site: ", .Library.site)
message("getwd():", getwd())
env = Sys.getenv()
env_pbs = env[grep('^PBS_', names(env))]
print(env_pbs)
message("TMPDIR: ", Sys.getenv("TMPDIR"))
