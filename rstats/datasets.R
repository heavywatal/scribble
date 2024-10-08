library(tidyverse)
# https://stat.ethz.ch/R-manual/R-patched/library/datasets/html/00Index.html

# ability.cov
# airmiles
# AirPassengers
airquality |>
  as_tibble() |>
  print() |>
  dplyr::summarize(across(everything(), \(x) mean(x, na.rm = TRUE)), .by = Month)

tidy_anscombe = anscombe |>
  tibble::rowid_to_column("id") |>
  tidyr::pivot_longer(!id,
    names_to = c("axis", "group"),
    names_sep = 1L,
    names_transform = list(group = as.integer)
  ) |>
  tidyr::pivot_wider(id_cols = c(id, group), names_from = axis) |>
  dplyr::select(!id) |>
  dplyr::arrange(group) |>
  print()

tidy_anscombe |>
  dplyr::group_by(group) |>
  dplyr::summarize(
    x_mean = mean(x), x_sd = sd(x),
    y_mean = mean(y), y_sd = sd(y),
    cor_xy = cor(x, y)
  )

tidy_anscombe |>
  tidyr::nest(data = !group) |>
  dplyr::mutate(data = purrr::map(data, \(.x) {
    .x |>
      dplyr::summarize(across(everything(), list(mean = mean, sd = sd))) |>
      dplyr::mutate(cor = cor(.x$x, .x$y))
  })) |>
  tidyr::unnest(data)

tidy_anscombe |>
  ggplot() + aes(x, y) +
  geom_point(size = 2) +
  stat_smooth(method = lm, se = FALSE, fullrange = TRUE) +
  stat_summary(fun.data = mean_se) +
  facet_wrap(vars(group))

# attenu
# attitude
# austres

# beaver1 beaver2
# BJsales
# BOD

# cars
ChickWeight |>
  ggplot() + aes(Time, weight, group = Chick) +
  geom_line(aes(colour = Diet)) +
  theme_bw()

chickwts |>
  dplyr::group_by(feed) |>
  dplyr::summarize(across(everything(), list(mean = mean, sd = sd, n = length)))

chickwts |>
  as_tibble() |>
  ggplot() + aes(weight) +
  geom_histogram(bins = 10) +
  facet_wrap(vars(feed)) +
  theme_bw()
# co2
# crimtab

# discoveries
DNase

esoph
# euro
# eurodist
# EuStockMarkets

(faithful |>
  ggplot() + aes(eruptions, waiting) +
  geom_point()) |>
  ggExtra::ggMarginal(type = "histogram")

# freeny
# Formaldehyde

HairEyeColor
# Harman23.cor
# Harman74.cor

Indometh
# infert
InsectSprays |> head()
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
OrchardSprays |> head()

OrchardSprays |>
  tidyr::pivot_wider(names_from = colpos, values_from = c(decrease, treatment))

PlantGrowth |>
  dplyr::group_by(group) |>
  dplyr::summarize(across(everything(), mean))
# precip
# presidents
pressure
# Puromycin

quakes |>
  ggplot() + aes(long, lat) +
  geom_point(aes(size = mag, color = depth), alpha = 0.4) +
  scale_size_continuous(name = "magnitude", range = c(1, 6), guide = guide_legend(reverse = TRUE)) +
  scale_colour_viridis_c(option = "magma", direction = -1, guide = guide_colourbar(reverse = TRUE)) +
  labs(title = "Quakes", x = "Longitude", y = "Latitude") +
  theme_gray(base_size = 14) +
  theme(
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#8090a0")
  )

# randu |> ggplot(aes(x, y, colour=z))+geom_point()
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
) |>
  bind_cols(as_tibble(state.x77)) |>
  bind_cols(state.center)

# sunspot.month sunspot.year sunspots
# swiss

# Theoph |> head()
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
USPersonalExpenditure |>
  as.data.frame() |>
  tibble::rownames_to_column("category") |>
  tidyr::pivot_longer(!category, names_to = "year", names_transform = list(year = as.integer), values_to = "dollar")
# uspop

va_deaths = VADeaths |>
  as.data.frame() |>
  tibble::rownames_to_column("class") |>
  tibble::as_tibble() |>
  tidyr::separate(class, c("lbound", "ubound"), "-", convert = TRUE) |>
  print() |>
  tidyr::pivot_longer(!matches("bound$"),
    names_to = c("region", "sex"),
    names_sep = " ",
    values_to = "death_rate"
  ) |>
  dplyr::mutate(death_rate = death_rate * 0.1) |>
  print()

ggplot(va_deaths) +
  aes(lbound, death_rate) +
  geom_line(aes(colour = sex, linetype = region), size = 1) +
  theme_bw()

# volcano

# warpbreaks
# women
# WWWusage

WorldPhones |>
  as.data.frame() |>
  tibble::rownames_to_column("year") |>
  dplyr::mutate(year = as.integer(year)) |>
  tidyr::pivot_longer(!year, names_to = "country", values_to = "phones") |>
  ggplot() +
  aes(year, phones) +
  geom_line(aes(colour = country)) +
  theme_bw()


# #######1#########2#########3#########4#########5#########6#########7#########
# ggplot2

ggplot(diamonds) +
  aes(carat, price) +
  geom_point(aes(colour = clarity), alpha = 0.5) +
  facet_grid(vars(cut), vars(color)) +
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

gp = ggplot(diamonds) +
  geom_point(shape = 16, alpha = 0.33) +
  coord_fixed(xlim = c(0, 60), ylim = c(0, 60)) +
  theme_minimal(13) +
  theme(legend.position = "none")
xy = gp + aes(x, y)
yz = gp + aes(y, z)
zx = gp + aes(z, x)
cowplot::plot_grid(xy, yz, zx)

diamonds |>
  dplyr::mutate(depth_xyz = 200 * z / (x + y)) |>
  ggplot() +
  aes(depth, depth_xyz) +
  geom_point(shape = 16, alpha = 0.33)


seals |>
  dplyr::mutate(v = sqrt(delta_lat**2 + delta_long**2)) |>
  ggplot() +
  aes(x = long, y = lat, colour = v) +
  geom_segment(
    aes(xend = long + delta_long, yend = lat + delta_lat),
    arrow = arrow(length = unit(1.5, "mm")), size = 1
  ) +
  scale_colour_viridis_c(option = "magma", end = 0.7, guide = "none") +
  labs(title = "Seals", x = "Longitude", y = "Latitude") +
  theme_bw(base_size = 14)

economics_long |>
  tidyr::pivot_wider(!value01, names_from = variable, values_from = value)


# #######1#########2#########3#########4#########5#########6#########7#########
# install.packages("AER")
library(AER)
data_AER = data(package = "AER")[["results"]] |>
  tibble::as_tibble() |>
  dplyr::select(!LibPath) |>
  print()
data_AER[["Item"]] |>
  paste(collapse = "\n") |>
  cat("\n")
data(list = data_AER[["Item"]], package = "AER")

Affairs |> as_tibble()
ArgentinaCPI
BankWages |> as_tibble()
BenderlyZwick
BondYield
CASchools |> as_tibble()
CPS1985 |> as_tibble()
CPS1988 |> as_tibble()
CPSSW04 |> as_tibble()
CPSSW3 |> as_tibble()
CPSSW8 |> as_tibble()
CPSSW9204 |> as_tibble()
CPSSW9298 |> as_tibble()
CPSSWEducation |> as_tibble()
CartelStability |> as_tibble()
ChinaIncome
CigarettesB |>
  tibble::rownames_to_column("state") |>
  tibble::as_tibble()
CigarettesSW |> as_tibble()
CollegeDistance |> as_tibble()
ConsumerGood
CreditCard |> as_tibble()
DJFranses
DJIA8012
DoctorVisits |> as_tibble()
DutchAdvert
DutchSales
Electricity1955 |> as_tibble()
Electricity1970 |>
  tibble::rownames_to_column() |>
  tibble::as_tibble()
EquationCitations |> as_tibble()
Equipment |>
  tibble::rownames_to_column("state") |>
  tibble::as_tibble()
EuroEnergy |>
  tibble::rownames_to_column("country") |>
  tibble::as_tibble()
Fatalities |> as_tibble()
Fertility |> as_tibble()
Fertility2 |> as_tibble()
FrozenJuice
GSOEP9402 |> as_tibble()
GSS7402 |> as_tibble()
GermanUnemployment
GoldSilver
GrowthDJ |> as_tibble()
GrowthSW |>
  tibble::rownames_to_column("country") |>
  tibble::as_tibble()
Grunfeld |> as_tibble()
Guns |> as_tibble()
HMDA |> as_tibble()
HealthInsurance |> as_tibble()
HousePrices |> as_tibble()
Journals |>
  tibble::rownames_to_column("abbrev") |>
  tibble::as_tibble()
KleinI
Longley
MASchools |> as_tibble()
MSCISwitzerland
ManufactCosts
MarkDollar
MarkPound
Medicaid1986 |> as_tibble()
Mortgage |> as_tibble()
MotorCycles
MotorCycles2
Municipalities |> as_tibble()
MurderRates |> as_tibble()
NMES1988 |> as_tibble()
NYSESW
NaturalGas |> as_tibble()
OECDGas |> as_tibble()
OECDGrowth |>
  tibble::rownames_to_column("country") |>
  tibble::as_tibble()
OlympicTV |>
  tibble::rownames_to_column("city") |>
  tibble::as_tibble()
OrangeCounty
PSID1976 |> as_tibble()
PSID1982 |> as_tibble()
PSID7682 |> as_tibble()
Parade2005 |> as_tibble()
PepperPrice
PhDPublications |> as_tibble()
ProgramEffectiveness |> as_tibble()
RecreationDemand |> as_tibble()
ResumeNames |> as_tibble()
SIC33 |> as_tibble()
STAR |> as_tibble()
ShipAccidents |> as_tibble()
SmokeBan |> as_tibble()
SportsCards |> as_tibble()
StrikeDuration |> as_tibble()
SwissLabor |> as_tibble()
TeachingRatings |> as_tibble()
TechChange
TradeCredit
TravelMode |> as_tibble()
UKInflation
UKNonDurables
USAirlines |> as_tibble()
USConsump1950
USConsump1979
USConsump1993
USCrudes |> as_tibble()
USGasB
USGasG
USInvest
USMacroB
USMacroG
USMacroSW
USMacroSWM
USMacroSWQ
USMoney
USProdIndex
USSeatBelts |> as_tibble()
USStocksSW
WeakInstrument |> as_tibble()


# #######1#########2#########3#########4#########5#########6#########7#########
# install.packages("COUNT")
library(COUNT)
data_COUNT = data(package = "COUNT")[["results"]] |>
  tibble::as_tibble() |>
  dplyr::select(!LibPath) |>
  print()
data(list = data_COUNT[["Item"]], package = "COUNT")

affairs |> as_tibble()
azcabgptca |> as_tibble()
azdrg112 |> as_tibble()
azpro |> as_tibble()
azprocedure |> as_tibble()

badhealth |>
  tibble::as_tibble() |>
  ggplot() +
  aes(numvisit, badh) +
  geom_jitter(aes(color = age), height = 0.2, width = 0, alpha = 0.5) +
  stat_smooth(formula = y ~ x, method = glm, method.args = list(family = binomial))

fasttrakg |> as_tibble()
fishing |> as_tibble()
lbw |> as_tibble()
lbwgrp |> as_tibble()
loomis |> as_tibble()
mdvis |> as_tibble() |> plot()
medpar |> as_tibble()
nuts |> as_tibble()
rwm |> as_tibble() |> plot()
rwm1984 |> as_tibble()
rwm5yr |> as_tibble()
ships |> as_tibble()
smoking |> as_tibble()
titanic |> as_tibble()
titanicgrp |> as_tibble()

MASS::ships |>
  tibble::as_tibble() |>
  ggplot() +
  aes(log10(service), incidents) +
  geom_point(aes(color = type), alpha = 0.6)


construction

who_tidy = who |>
  dplyr::filter(iso2 %in% c("JP", "FI", "DE")) |>
  tidyr::pivot_longer(matches("^new")) |>
  tidyr::drop_na() |>
  dplyr::mutate(name = stringr::str_remove(name, "^new_?")) |>
  tidyr::separate(name, c("diagnosis", "name")) |>
  tidyr::separate(name, c("sex", "age"), 1L) |>
  dplyr::mutate(age = stringr::str_replace(age, "(\\d5|0)", "\\1-")) |>
  print()

ggplot(who_tidy) +
  aes(year, value) +
  geom_line(aes(color = age, linetype = sex)) +
  facet_grid(vars(country), vars(diagnosis))

billboard |>
  dplyr::filter(if_any(matches("^wk"), \(x) x == 1)) |>
  tidyr::pivot_longer(matches("^wk"), names_to = "week", values_to = "rank") |>
  tidyr::drop_na() |>
  dplyr::mutate(week = readr::parse_number(week)) |>
  ggplot() +
  aes(week, rank, group = track) +
  geom_line(aes(color = track)) +
  scale_y_reverse()

billboard |>
  dplyr::count(artist) |>
  dplyr::arrange(desc(n)) |>
  dplyr::filter(n > 1L)
