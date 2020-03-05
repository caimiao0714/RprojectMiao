library(ggplot2)
library(ggtext)


# A random test
ggplot(mtcars, aes(mpg, cyl)) +
  geom_point() +
  ggtitle("This is a **test**") +
  theme(plot.title = element_markdown(hjust = 0.5))

library(sf)
library(USAboundaries)
crs_use = "+proj=laea +lat_0=30 +lon_0=-95"
d_points = data.frame(long = c(-110, -103, -84),
                      lat  = c(45, 40, 41),
                      map_color = c("A", "B", "C")) %>%
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>%
  st_transform(crs = crs_use)
usa_sf = us_boundaries(type = "state", resolution = "low") %>%
  dplyr::filter(!state_abbr %in% c("PR", "AK", "HI")) %>%
  st_transform(crs = crs_use)

library(data.table)
library(dplyr)
d = fst::read_fst("01a_ping_original_500drivers.fst") %>%
  as.data.table# read ping

pd = function(dt){#plot data
  agg_p = dt[,.(lat = round(lat, 2), long = round(lon, 2))]

  maxping = agg_p %>%
    .[,.(n_ping = .N),.(lat, long)] %>%
    .[, max(n_ping)]

  fdt = agg_p %>%
    .[,.(n_ping = .N),.(lat, long)] %>%
    .[,ping_quart := Hmisc::cut2(n_ping, g = 5)] %>%
    .[,ping_quart := sapply(stringr::str_extract_all(ping_quart, "\\d+"),
                            function(x) paste(x, collapse="-"))] %>%
    .[,ping_quart := case_when(
      grepl(maxping, ping_quart) ~ paste0(">=", gsub(paste0("-", maxping),
                                                     "", ping_quart)),
      TRUE ~ ping_quart)]

  correct_levels = fdt[,.N, ping_quart] %>%
    .[,ping_quart] %>%
    .[order(as.integer(gsub("(-\\d+)|(>=)", "", .)))]

  fdt = fdt %>%
    .[,ping_quart := factor(ping_quart, levels = correct_levels)] %>%
    st_as_sf(coords = c("long", "lat"), crs = 4326) %>%
    st_transform(crs = crs_use)

  return(fdt)
}

pp = d %>%
  .[speed == 0] %>%
  pd()


ggplot() +
  geom_sf(data = usa_sf) +
  geom_sf(data = pp, aes(color = ping_quart), size = 5) +
  coord_sf(crs = crs_use) +
  theme_minimal() +
  ggtitle("This is aother **test**") +
  theme(plot.title = element_markdown(hjust = 0.5))
