library(sf)
library(ggplot2)
# devtools::install_github("hrbrmstr/albersusa")
library(albersusa)
crs_use = "+proj=laea +lat_0=30 +lon_0=-95"

d_points = data.frame(long = c(-110, -103, -84),
                      lat  = c(45, 40, 41))


A = ggplot(data = usa_sf()) +
  geom_sf() +
  geom_point(data = d_points,
             aes(x = long, y = lat),
             color = "red", size = 5) +
  theme_minimal() +
  ggtitle("(A) right point position, wrong projection")

B = ggplot(data = usa_sf()) +
  geom_sf() +
  geom_point(data = d_points,
             aes(x = long, y = lat),
             color = "red", size = 5) +
  coord_sf(crs = crs_use) +
  theme_minimal() +
  ggtitle("(B) right projection, wrong points using geom_point()")

C = ggplot() +
  geom_sf(data = usa_sf()) +
  geom_sf(data = st_as_sf(d_points,
                          coords = c("long", "lat"), crs = crs_use),
          color = "red", size = 5) +
  coord_sf(crs = crs_use) +
  theme_minimal() +
  ggtitle("(C) right projection, wrong points using geom_sf() points")

cowplot::plot_grid(A, B, C, nrow = 3)
