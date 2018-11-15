# install.packages(c("sf", "rnaturalearth", "rgeos"))

library(tidyverse)
library(sf)
library(rnaturalearth)
library(ggrepel)

sf_japan = ne_countries(scale = 10, country = "japan", returnclass= "sf")

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

p = ggplot(sf_japan) +
  geom_sf(fill = gray(0.7), lwd = 0) +
  coord_sf(xlim = c(139.5, 141.6), ylim = c(34.85, 38.45), expand = FALSE, label_graticule="") +
  geom_point(data = cities, aes(longitude, latitude)) +
  geom_text_repel(data = cities, aes(longitude, latitude, label = name)) +
  labs(x=NULL, y=NULL)
p
ggsave("map-sendai-yokosuka.png", p, height = 6, width = 3)
