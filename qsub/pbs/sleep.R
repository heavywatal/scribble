#!/usr/bin/env Rscript
sleep = function(x) {
  Sys.sleep(3)
  x
}
v = seq_len(getOption("mc.cores", 2L))
print(Sys.time())
.devnull = parallel::mclapply(v, sleep)
print(Sys.time())
print(unlist(.devnull))
