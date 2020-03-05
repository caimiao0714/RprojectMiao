# https://stackoverflow.com/questions/60550186/find-the-state-where-the-points-are-located-in-sf-r
library(sf)
library(ggplot2)
library(dplyr)

usa = st_as_sf(maps::map("state", fill = TRUE, plot = FALSE))

pts = data.frame(
  x = c(-91.6, -74.3, -101.5),
  y = c(36.1, 42.1, 25.3)
) %>%
  st_as_sf(coords=c("x", "y"), crs = 4326)

ggplot() +
  geom_sf(data = usa, fill = NA) +
  geom_sf(data = pts,
          shape = 21, size = 4, fill = "red") +
  coord_sf(crs = st_crs(102003)) +
  theme_minimal()