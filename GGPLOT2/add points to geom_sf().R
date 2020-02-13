library(sf)
library(ggplot2)
library(USAboundaries)
crs_use = "+proj=laea +lat_0=30 +lon_0=-95"

d_points = data.frame(long = c(-110, -103, -84),
                      lat  = c(45, 40, 41))
usa_sf = us_boundaries(type = "state", resolution = "low") %>%
  dplyr::filter(!state_abbr %in% c("PR", "AK", "HI")) %>%
  st_transform(crs = crs_use)

A = ggplot(data = usa_sf) +
  geom_sf() +
  geom_point(data = d_points,
             aes(x = long, y = lat),
             color = "red", size = 5) +
  theme_minimal() +
  ggtitle("(A) right point position, wrong projection")

B = ggplot(data = usa_sf) +
  geom_sf() +
  geom_point(data = d_points,
             aes(x = long, y = lat),
             color = "red", size = 5) +
  coord_sf(crs = crs_use) +
  theme_minimal() +
  ggtitle("(B) right projection, wrong points using geom_point()")

C = ggplot() +
  geom_sf(data = usa_sf) +
  geom_sf(data = st_as_sf(d_points,
                          coords = c("long", "lat"), crs = crs_use),
          color = "red", size = 5) +
  coord_sf(crs = crs_use) +
  theme_minimal() +
  ggtitle("(C) right projection, wrong points using geom_sf() points")

cowplot::plot_grid(A, B, C, nrow = 3)

ggplot() +
  geom_sf(data = usa_sf) +
  geom_sf(data = st_as_sf(d_points,
                          coords = c("long", "lat"), crs = 4326) %>%
            st_transform(crs = crs_use),
          color = "red", size = 5) +
  coord_sf(crs = crs_use) +
  theme_minimal() +
  ggtitle("(C) right projection, wrong points using geom_sf() points")

