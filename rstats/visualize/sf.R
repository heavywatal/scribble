library(tidyverse)
library(sf)
library(ggrepel)

cities = readr::read_csv("name,latitude,longitude
Yokosuka,35.281836,139.663917
Yokohama,35.465669,139.622366
Tokyo,35.680770,139.767360
Sendai,38.259734,140.882282
") %>% print()

universities = readr::read_csv("name,latitude,longitude
Sokendai,35.260736,139.607303
Tohoku Univ.,38.257956,140.836707
") %>% print()

# #######1#########2#########3#########4#########5#########6#########7#########

# remotes::install_github("ropensci/rnaturalearth")
library(rnaturalearth)

sf_japan = ne_countries(scale = 10, country = "japan", returnclass = "sf")

p0 = ggplot(sf_japan) +
  geom_sf(fill = gray(0.7), lwd = 0) +
  coord_sf(xlim = c(139.5, 141.6), ylim = c(34.85, 38.45), expand = FALSE, label_graticule = "") +
  labs(x = NULL, y = NULL)
p0

p = p0 +
  geom_point(data = cities, aes(longitude, latitude)) +
  geom_text_repel(data = cities, aes(longitude, latitude, label = name))
p
ggsave("map-sendai-yokosuka.png", p, height = 6, width = 3)

# #######1#########2#########3#########4#########5#########6#########7#########

# remotes::install_github("uribo/jpndistrict")
library(jpndistrict)
sf::sf_use_s2(FALSE)

prefectures = purrr::map_dfr(2:19, jpndistrict::jpn_pref, district = FALSE) %>% print()

pu = prefectures %>%
  ggplot() +
  geom_sf(size = 0.05, fill = "#aaaaaa") +
  geom_point(data = universities, aes(longitude, latitude)) +
  geom_text_repel(data = universities, aes(longitude, latitude, label = name)) +
  coord_sf(xlim = c(139.4, 141.7), ylim = c(35, 39)) +
  theme_minimal() +
  theme(axis.text = element_blank(), axis.title = element_blank())
pu
ggsave("map-universities.png", pu, height = 4, width = 2)


admins = jpndistrict::jpn_admins(c(4, 14)) %>%
  dplyr::filter(str_detect(name, "仙台市役所|横須賀|葉山町")) %>%
  dplyr::mutate(name = str_replace(name, "市役所|町役場", "")) %>%
  print()

separate_sfc = function(geometry) {
  purrr::map_dfr(geometry, ~{
    setNames(as.vector(.x), c("longitude", "latitude"))
  })
}
admins[["geometry"]] %>% separate_sfc()

flatten_sf = function(data) {
  data %>%
    tibble::as_tibble() %>%
    dplyr::mutate(geometry = separate_sfc(geometry)) %>%
    tidyr::unpack(geometry)
}
admins %>% flatten_sf()

pu + geom_sf_text(data = admins, aes(label = name), family = "Hiragino Sans W3")

# #######1#########2#########3#########4#########5#########6#########7#########

# install.packages("NipponMap")
library(NipponMap)

jpn_shp = system.file("shapes/jpn.shp", package = "NipponMap") %>%
  sf::read_sf(crs = "+proj=longlat +datum=WGS84") %>%
  print()

jpn_shp %>%
  ggplot() +
  geom_sf(aes(fill = population), size = 0.1) +
  scale_fill_viridis_c() +
  coord_sf(xlim = c(139, 142), ylim = c(35, 39))
