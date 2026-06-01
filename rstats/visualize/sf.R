library(tidyverse)
library(sf)
library(ggrepel)

.csv = "name,latitude,longitude
Yokosuka,35.281836,139.663917
Yokohama,35.465669,139.622366
Tokyo,35.680770,139.767360
Sendai,38.259734,140.882282
"
cities = readr::read_csv(I(.csv)) |> print()

# #######1#########2#########3#########4#########5#########6#########7#########

# pak::pak("ropensci/rnaturalearth")
# pak::pak("ropensci/rnaturalearthhires")
library(rnaturalearth)

sf_japan = ne_countries(scale = 10, country = "japan", returnclass = "sf")

p0 = ggplot(sf_japan) +
  geom_sf(fill = gray(0.7), lwd = 0) +
  coord_sf(
    xlim = c(139.5, 141.6),
    ylim = c(34.85, 38.45),
    expand = FALSE,
    label_graticule = ""
  )
p0

p = p0 +
  geom_point(data = cities, aes(longitude, latitude)) +
  geom_text_repel(data = cities, aes(longitude, latitude, label = name)) +
  labs(x = NULL, y = NULL)
p
ggsave("map-sendai-yokosuka.png", p, height = 6, width = 3) |> wtl::oxipng()
ggsave("map-sendai-yokosuka.webp", p, height = 6, width = 3, device = ragg::agg_webp)

# #######1#########2#########3#########4#########5#########6#########7#########

# pak::pak("uribo/jpndistrict")
library(jpndistrict)
sf::sf_use_s2(FALSE)

.csv = "name,latitude,longitude,color
Sokendai,35.260736,139.607303,#E4007F
Tohoku Univ.,38.257956,140.836707,#3E1485
"
universities = readr::read_csv(I(.csv)) |> print()

sfs = purrr::map(2:19, \(x) jpndistrict::jpn_pref(x, district = FALSE))
prefectures = sfs |>
  purrr::list_rbind(ptype = sfs[[1]]) |>
  print()

pu = ggplot(prefectures) +
  geom_sf(linewidth = 0.4, fill = "#aaaaaa", color = "#ffffff") +
  geom_point(data = universities, aes(longitude, latitude, color = color)) +
  geom_text(
    aes(longitude, latitude, label = name, color = color),
    universities,
    size = 4.5,
    fontface = "bold",
    nudge_x = 0.1,
    nudge_y = 0.15
  ) +
  scale_color_identity() +
  coord_sf(xlim = c(139.3, 141.6), ylim = c(35, 39)) +
  theme_void(base_family = "Helvetica Neue")
pu
ggsave("map-universities.webp", pu, height = 4.8, width = 2.2, device = ragg::agg_webp)


admins = jpndistrict::jpn_admins(c(4, 14)) |>
  dplyr::filter(str_detect(name, "仙台市役所|横須賀|葉山町")) |>
  dplyr::mutate(name = str_replace(name, "市役所|町役場", "")) |>
  print()

pu + geom_sf_text(data = admins, aes(label = name), family = "Hiragino Sans W3")

# #######1#########2#########3#########4#########5#########6#########7#########

# pak::pak("NipponMap")
library(NipponMap)

jpn_shp = system.file("shapes/jpn.shp", package = "NipponMap") |>
  sf::read_sf(crs = "+proj=longlat +datum=WGS84") |>
  print()

jpn_shp |>
  ggplot() +
  geom_sf(aes(fill = population), size = 0.1) +
  scale_fill_viridis_c() +
  coord_sf(xlim = c(139, 142), ylim = c(35, 39))
