#!/usr/bin/env Rscript
#$ -S /opt/pkg/r/3.5.2/bin/Rscript
#$ -l short
#$ -cwd

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
