library(tidyverse)
# https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html

# ability.cov
# airmiles
# AirPassengers
airquality %>%
  dplyr::group_by(Month) %>%
  dplyr::summarise_all(mean, na.rm=TRUE)

tidy_anscombe = anscombe %>%
  tibble::rownames_to_column('id') %>%
  tidyr::gather(key, value, -id) %>%
  tidyr::separate(key, c('axis', 'group'), 1L) %>%
  tidyr::spread(axis, value) %>%
  dplyr::select(-id) %>%
  dplyr::arrange(group) %>%
  print()

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
  ggplot(aes(x, y))+
  geom_point(size=3)+
  stat_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  facet_wrap(~group, nrow=1L)

tidy_anscombe %>%
  ggplot(aes(x, y))+
  geom_point(size=2)+
  stat_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  stat_summary(fun.data=mean_se)+
  facet_wrap(~group)

# attenu
# attitude
# austres

# beaver1 beaver2
# BJsales
# BOD

# cars
ChickWeight
chickwts %>% dplyr::group_by(feed) %>% dplyr::summarise_all(funs(mean, sd, length))
# co2
# crimtab

# discoveries
DNase

esoph
# euro
# eurodist
# EuStockMarkets

(faithful %>%
  ggplot(aes(eruptions, waiting))+
  geom_point()) %>%
  ggExtra::ggMarginal(type='histogram')

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
Loblolly %>% head()
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

PlantGrowth %>% dplyr::group_by(group) %>% dplyr::summarise_all(mean)
# precip
# presidents
pressure
# Puromycin

quakes %>%
  ggplot(aes(long, lat))+
  geom_point(aes(size=mag, colour=depth), alpha=0.5)+
  theme_bw()

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
  region = state.region) %>%
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
ldeaths  # mdeaths + fdeaths
# UKgas
# USAccDeaths
# USArrests
# USJudgeRatings
USPersonalExpenditure %>% as.data.frame() %>% rownames_to_column('category') %>% tidyr::gather(year, dollar, -category)
# uspop

va_deaths = VADeaths %>%
  as.data.frame() %>%
  tibble::rownames_to_column('class') %>%
  as_tibble() %>%
  tidyr::separate(class, c('lbound', 'ubound'), '-', convert=TRUE) %>%
  print() %>%
  tidyr::gather(people, death_rate, -lbound, -ubound) %>%
  tidyr::separate(people, c("region", "sex"), " ") %>%
  dplyr::mutate(death_rate = death_rate * 0.1) %>%
  print()

ggplot(va_deaths, aes(lbound, death_rate))+
  geom_line(aes(colour = sex, linetype=region), size=1)+
  theme_bw()

# volcano

# warpbreaks
# women
# WWWusage

WorldPhones %>%
  as.data.frame() %>%
  rownames_to_column('year') %>%
  dplyr::mutate(year = as.integer(year)) %>%
  tidyr::gather(country, phones, -year) %>%
  ggplot(aes(year, phones))+
  geom_line(aes(colour=country))+
  theme_bw()
