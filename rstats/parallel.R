# random number and reproducibility

options(mc.cores = parallel::detectCores(logical = FALSE))

rint = function(..., n = 65535L, size = 3L) sample.int(n, size)

# sequential
set.seed(19937)
lapply(seq_len(4L), rint) |> simplify2array()
set.seed(19937)
lapply(seq_len(4L), rint) |> simplify2array()

# default mc.set.seed = TRUE; not reproducible
set.seed(19937)
parallel::mclapply(seq_len(4L), rint) |> simplify2array()
set.seed(19937)
parallel::mclapply(seq_len(4L), rint) |> simplify2array()

# reproducible, but duplicated
set.seed(19937)
parallel::mclapply(seq_len(6L), rint, mc.set.seed = FALSE, mc.cores = 2L) |> simplify2array()

# reproducible; note that RNG state (.Random.seed) remains the same
RNGkind("L'Ecuyer-CMRG")
set.seed(19937)
parallel::mclapply(seq_len(4L), rint) |> simplify2array()
parallel::mclapply(seq_len(4L), rint) |> simplify2array()
invisible(runif(1))
parallel::mclapply(seq_len(4L), rint) |> simplify2array()
set.seed(19937)
parallel::mclapply(seq_len(4L), rint) |> simplify2array()

# same results
set.seed(19937)
lapply(seq_len(2), \(i) {
  parallel::mclapply(seq_len(4L), rint) |> simplify2array()
})

# advance RNG state
set.seed(19937)
lapply(seq_len(2), \(i) {
  on.exit(runif(1L)) # proxy of parallel::nextRNGStream(.Random.seed)
  parallel::mclapply(seq_len(4L), rint) |> simplify2array()
})
