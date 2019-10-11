library(tidyverse)
# https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html

# ability.cov
# airmiles
# AirPassengers
airquality %>%
  dplyr::group_by(Month) %>%
  dplyr::summarise_all(mean, na.rm = TRUE)

tidy_anscombe = anscombe %>%
  tibble::rowid_to_column("id") %>%
  tidyr::pivot_longer(-id,
    names_to = c("axis", "group"),
    names_sep = 1L,
    names_ptypes = list(group = integer())) %>%
  tidyr::pivot_wider(c(id, group), names_from = axis) %>%
  dplyr::select(-id) %>%
  dplyr::arrange(group)

tidy_anscombe %>%
  dplyr::group_by(group) %>%
  dplyr::summarise(
    x_mean = mean(x), x_sd = sd(x),
    y_mean = mean(y), y_sd = sd(y),
    cor_xy = cor(x, y)
  )

tidy_anscombe %>%
  tidyr::nest(-group) %>%
  dplyr::mutate(data = purrr::map(data, ~{
    summarise_all(.x, funs(mean, sd)) %>%
      dplyr::mutate(cor = cor(.x$x, .x$y))
  })) %>%
  tidyr::unnest()

tidy_anscombe %>%
  ggplot(aes(x, y)) +
  geom_point(size = 3) +
  stat_smooth(method = lm, se = FALSE, fullrange = TRUE) +
  facet_wrap(~group, nrow = 1L)

tidy_anscombe %>%
  ggplot(aes(x, y)) +
  geom_point(size = 2) +
  stat_smooth(method = lm, se = FALSE, fullrange = TRUE) +
  stat_summary(fun.data = mean_se) +
  facet_wrap(~group)

# attenu
# attitude
# austres

# beaver1 beaver2
# BJsales
# BOD

# cars
ChickWeight %>%
  ggplot(aes(Time, weight, group = Chick)) +
  geom_line(aes(colour = Diet)) +
  theme_bw()

chickwts %>% dplyr::group_by(feed) %>% dplyr::summarise_all(funs(mean, sd, length))

chickwts %>%
  as_tibble() %>%
  ggplot(aes(weight)) +
  geom_histogram(bins = 10) +
  facet_wrap(~feed) +
  theme_bw()
# co2
# crimtab

# discoveries
DNase

esoph
# euro
# eurodist
# EuStockMarkets

(faithful %>%
  ggplot(aes(eruptions, waiting)) +
  geom_point()) %>%
  ggExtra::ggMarginal(type = "histogram")

# freeny
# Formaldehyde

HairEyeColor
# Harman23.cor
# Harman74.cor

Indometh
# infert
InsectSprays %>% head()
iris
iris3
# islands

# JohnsonJohnson

# LakeHuron
# lh
# LifeCycleSavings
# Loblolly
# longley
# lynx

# morley
mtcars

# nhtemp
# Nile
# nottem
# npk

# occupationalStatus
# Orange
OrchardSprays %>% head()

OrchardSprays %>% tidyr::pivot_wider(names_from = colpos, values_from = c(decrease, treatment))

PlantGrowth %>% dplyr::group_by(group) %>% dplyr::summarise_all(mean)
# precip
# presidents
pressure
# Puromycin

quakes %>%
  ggplot(aes(long, lat)) +
  geom_point(aes(size = mag, colour = depth), alpha = 0.4) +
  scale_size_continuous(name = "magnitude", range = c(1, 6), guide = guide_legend(reverse = TRUE)) +
  scale_colour_viridis_c(option = "magma", direction = -1, guide = guide_colourbar(reverse = TRUE)) +
  labs(title = "Quakes", x = "Longitude", y = "Latitude") +
  theme_gray(base_size = 14) +
  theme(
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#8090a0"),
  )

# randu %>% ggplot(aes(x, y, colour=z))+geom_point()
# rivers
# rock

Seatbelts
# sleep
# stackloss

tibble::tibble(
  name = state.name,
  abb = state.abb,
  division = state.division,
  region = state.region
) %>%
  bind_cols(as_tibble(state.x77)) %>%
  bind_cols(state.center)

# sunspot.month sunspot.year sunspots
# swiss

# Theoph %>% head()
Titanic
# ToothGrowth
# treering
# trees

UCBAdmissions
UKDriverDeaths
ldeaths # mdeaths + fdeaths
# UKgas
# USAccDeaths
# USArrests
# USJudgeRatings
USPersonalExpenditure %>% as.data.frame() %>% rownames_to_column("category") %>%
  tidyr::pivot_longer(-category, "year", names_ptypes = list(year = integer()), values_to = "dollar")
# uspop

va_deaths = VADeaths %>%
  as.data.frame() %>%
  tibble::rownames_to_column("class") %>%
  as_tibble() %>%
  tidyr::separate(class, c("lbound", "ubound"), "-", convert = TRUE) %>%
  print() %>%
  tidyr::pivot_longer(c(-lbound, -ubound),
    names_to = c("region", "sex"),
    names_sep = " ",
    values_to = "death_rate") %>%
  dplyr::mutate(death_rate = death_rate * 0.1) %>%
  print()

ggplot(va_deaths, aes(lbound, death_rate)) +
  geom_line(aes(colour = sex, linetype = region), size = 1) +
  theme_bw()

# volcano

# warpbreaks
# women
# WWWusage

WorldPhones %>%
  as.data.frame() %>%
  rownames_to_column("year") %>%
  dplyr::mutate(year = as.integer(year)) %>%
  tidyr::pivot_longer(-year, "country", values_to = "phones") %>%
  ggplot(aes(year, phones)) +
  geom_line(aes(colour = country)) +
  theme_bw()


# #######1#########2#########3#########4#########5#########6#########7#########
# ggplot2

ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(colour = clarity), alpha = 0.5) +
  facet_grid(cut ~ color) +
  scale_colour_viridis_d(
    guide = guide_legend(reverse = TRUE, override.aes = list(alpha = 1))
  ) +
  labs(title = "Diamonds") +
  theme_gray(base_size = 14) +
  theme(
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "#aaaaaa"),
    legend.key = element_rect(fill = "#aaaaaa"),
    axis.text = element_blank(), axis.ticks = element_blank()
  )

seals %>%
  dplyr::mutate(v = sqrt(delta_lat ** 2 + delta_long ** 2)) %>%
  ggplot(aes(x = long, y = lat, colour = v)) +
  geom_segment(
    aes(xend = long + delta_long, yend = lat + delta_lat),
    arrow = arrow(length = unit(1.5, "mm")), size = 1
  ) +
  scale_colour_viridis_c(option = "magma", end = 0.7, guide = FALSE) +
  labs(title = "Seals", x = "Longitude", y = "Latitude") +
  theme_bw(base_size = 14)

economics_long %>%
  tidyr::pivot_wider(-value01, names_from = variable, values_from = value)
