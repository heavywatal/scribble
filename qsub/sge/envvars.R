#!/usr/bin/env Rscript

#$ -S /usr/bin/Rscript
#$ -l short
#$ -cwd

sessionInfo()
message("Sys.timezone(): ", Sys.timezone())
message(".libPaths(): ", paste(.libPaths(), collapse = ":"))
message(".Library: ", .Library)
message(".Library.site: ", .Library.site)
message("getwd():", getwd())
env = Sys.getenv()
env_sge = env[grep("^SGE_", names(env))]
print(env_sge)
message("TMPDIR: ", Sys.getenv("TMPDIR"))
