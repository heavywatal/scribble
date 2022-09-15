library(future)
library(future.apply)
library(furrr)

plan(multiprocess)  # multicore, if supported, otherwise multisession
plan(multisession)  # background R sessions
plan(multicore)     # forked R processes (UNIX)

.const = c(D = 3, L = "const", P = "random")
.alt = list(k = c(1, 1e6), N = 10240L)
args_tbl = tumopp::make_args(alt = .alt, const = .const, each = 6L)

bench::mark(
  tumopp::tumopp(args_tbl),
  tumopp:::vectorize_args(args_tbl) %>% purrr::map_dfr(tumopp::tumopp),
  tumopp:::vectorize_args(args_tbl) %>% furrr::future_map_dfr(tumopp::tumopp),
  check = FALSE, memory = FALSE
)
