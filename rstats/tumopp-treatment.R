library(tidyverse)
library(wtl)
library(rgl)
library(tumopp)
wtl::refresh('rtumopp')

.make_nested = function(population, graph, snapshots, resistant, ...) {
  num_clades = ifelse(resistant > 0L, 8L, 1L)
  clade_info = population %>%
    tumopp:::add_node_property(graph, num_clades) %>%
    dplyr::select(id, clade)
  # extant = population %>% tumopp::filter_extant()
  snapshots %>%
    dplyr::left_join(clade_info, by = "id") %>%
    # dplyr::bind_rows(extant %>% dplyr::mutate(time = max(.data$birth))) %>%
    tumopp::add_col() %>%
    tidyr::nest(-time) %>%
    dplyr::filter(3.0 < time) %>%
    dplyr::mutate(i = dplyr::row_number(time))
}

.snapshot_tumor3d = function(nested, max_abs=3, outdir=".", resistant=0L, ...) {
  if (rgl.cur()) {rgl.close()}
  if (resistant == 0L) {
    nested = nested %>% tibble::add_row(time = max(.$time + 0.5), data = list(NULL), i = max(.$i + 1L))
  }
  nested %>%
    purrr::pmap(function(time, data, i) {
      on.exit(rgl::rgl.close())
      rgl::open3d(useNULL = FALSE)
      tumopp::plot_tumor3d(data, limit = c(-max_abs, max_abs))
      filename = sprintf("%s/snapshot-%03d.png", outdir, i)
      rgl::snapshot3d(filename)
      filename
    })
}

ffmpeg_png_mp4 = function(infile, outfile="movie.mp4", framerate=5) {
    command = paste(
      "ffmpeg -y -framerate", framerate, "-i", infile,
      "-vcodec libx264 -pix_fmt yuv420p -an", outfile
    )
    message(command)
    system(command)
}

magick_gif_animation = function(infiles, outfile="animation.gif", delay = 15, loop = 1) {
  args = c("-loop", loop, "-delay", delay,
           infiles, "-layers", "Optimize", outfile)
  message(paste(args, collapse = " "))
  system2("magick", args)
}
results$outdir %>% purrr::walk(.ffmpeg_snapshots, framerate=5)

.make_animation = function(outdir=".", framerate=5) {
    infile = fs::path(outdir, "snapshot-%03d.png")
    outfile = fs::path(outdir, paste0(outdir, "-snapshots.mp4"))
    ffmpeg_png_mp4(infile, outfile, framerate=framerate)
    infiles = fs::dir_ls(outdir, glob = "*snapshot-*.png")
    outgif = fs::path(outdir, paste0(outdir, "-snapshots.gif"))
    magick_gif_animation(infiles, outgif)
}

# #######1#########2#########3#########4#########5#########6#########7#########

.const = c("-D3", "-Chex", "-k8", "-I0.5", "-N10000", "--treatment=0.99")
.alt = list(
  seed = c("1", "2", "3"),
  resistant = c("0", "3")
)

argslist = make_args(alt = .alt, const = .const, nreps = 1L)
print(names(argslist))
raw_results = tumopp::tumopp(argslist) %>% print()

results = raw_results %>%
  dplyr::select_if(~ n_distinct(.x) > 1L) %>%
  print()

.demography = results %>%
  dplyr::transmute(resistant, seed, demography = purrr::map(population, ~{
    .x %>% extract_history() %>% summarise_demography()
  })) %>%
  tidyr::unnest() %>%
  print()

.demography %>%
  dplyr::mutate(resistant = as.factor(resistant)) %>%
  ggplot(aes(time, size, colour = resistant)) +
  geom_line(alpha = 0.6, size = 2) +
  facet_grid(. ~ seed)

.p_demography = .demography %>%
  dplyr::filter(seed == min(seed)) %>%
  tibble::add_row(resistant = 0L, seed = 42L, time = max(.$time), size = min(.$size)) %>%
  dplyr::mutate(resistant = factor(resistant, levels=c('3', '0'))) %>%
  ggplot(aes(time, size, colour = resistant)) +
  geom_line(aes(size = resistant), alpha = 1) +
  scale_colour_manual(values=c(`0` = "#000000", `3` = "#ff3311"), guide = FALSE) +
  scale_size_manual(values=c(`0` = 2, `3` = 5), guide = FALSE) +
  wtl::erase(axis.ticks, axis.text, axis.title, panel.grid)
.p_demography

ggsave("demography.png", .p_demography, width=12, height=3)

results = results %>%
  dplyr::mutate(max_abs = purrr::map(population, tumopp::max_abs_xyz)) %>%
  dplyr::mutate(nested = purrr::pmap(., .make_nested))

results$nested[[1]]$data[[4]]

results = results %>%
  dplyr::mutate(outdir = sprintf("resistant%d-seed%d", resistant, seed)) %>%
  print()

fs::dir_create(results$outdir)

results %>% purrr::pwalk(.snapshot_tumor3d)

results$outdir %>% purrr::walk(.make_animation)

.label = "resistant0-seed1"
.infiles = sprintf("%s/snapshot-%03d.png", .label, seq(5, 29, 4)) %>% paste(collapse=" ")
.label = "resistant3-seed1"
.infiles = sprintf("%s/snapshot-%03d.png", .label, seq(7, 43, 4)) %>% paste(collapse=" ")

.outfile = paste0(.label, "-sequence.png")
system(paste("magick", .infiles, "+append", .outfile))

# fs::dir_ls(glob='snapshot-*.png') %>% fs::file_delete()
