pacman::p_load(sf, fst, ggplot2, data.table, dplyr, RColorBrewer, viridis)
source("figures/theme_map.R")
windowsFonts(Times = windowsFont("Times New Roman")) # For windows computer LM Roman 10
default_font_family = "Times"

# **************** Read in shape files ****************
crs_use = "+proj=laea +lat_0=35 +lon_0=-100"
us_road = sf::st_read("map_data/roadtrl010g.shp_nt00920/roadtrl010g.shp") %>%
  filter(!(STATE %in% c("AK", "HI", "PR", "VI")))%>%
  st_transform(crs = crs_use) # read major highway
us_border = sf::st_read("map_data/tl_2017_us_state/tl_2017_us_state.shp") %>%
  filter(!(STUSPS %in% c("AK", "HI", "PR", "VI", "MP", "GU", "AS"))) %>%
  st_transform(crs = crs_use)

# **************** Read in pings ****************
ping_active = as.data.table(read_fst('Data/map_ping_active.fst'))
ping_stop = as.data.table(read_fst('Data/map_ping_stop.fst'))

# **************** Transform pings into quintile ****************
pd = function(dt){
  maxping = dt[, max(N)]
  
  fdt = dt %>%
    .[,ping_quart := Hmisc::cut2(N, g = 5)] %>%
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
    st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
    st_transform(crs = crs_use)
  
  return(fdt)
}

ping_active1 = pd(ping_active)
ping_stop1 = pd(ping_stop)

# *********************************************************
# **************** Map with major highways ****************
# Active pings
p_active = ggplot() +
  geom_sf(data = us_border, fill = NA, color = "grey10", size = 0.6) +
  geom_sf(data = us_road,
          fill = NA, color = "grey20", size = 0.2) +
  geom_sf(data = ping_active1, aes(color = ping_quart),
          shape = 16, alpha = 0.5, size = 0.4) +
  scale_color_manual(values = RColorBrewer::brewer.pal(9, 'Reds')[4:8]) +
  coord_sf(crs = st_crs(crs_use)) +
  guides(color = guide_legend(title = "Number of pings",
                             override.aes = list(alpha = 1, size = 5))) +
  labs(x = NULL, y = NULL) +
  theme_map(
    legend.justification = c(1, 1),
    legend.position = c(0.2, 0.25),
    legend.direction = "vertical",
    legend.spacing.x = unit(0.5, 'cm'),
    legend.spacing.y = unit(0.2, 'cm'),
    legend.key.size = unit(0.8, "lines"))

ggsave("Figures/Map_active_ping.jpeg", p_active,
       width = 10, height = 6.18, dpi = 600)


# Inactive pings
p_stop = ggplot() +
  geom_sf(data = us_border, fill = NA, color = "grey10", size = 0.6) +
  geom_sf(data = us_road,
          fill = NA, color = "grey20", size = 0.2) +
  geom_sf(data = ping_stop1, aes(color = ping_quart),
          shape = 16, alpha = 0.6, size = 0.7) +
  scale_color_manual(values = RColorBrewer::brewer.pal(9, 'Blues')[5:9]) +
  coord_sf(crs = st_crs(crs_use)) +
  guides(color = guide_legend(title = "Number of pings",
                              override.aes = list(alpha = 1, size = 5))) +
  labs(x = NULL, y = NULL) +
  theme_map(
    legend.justification = c(1, 1),
    legend.position = c(0.2, 0.25),
    legend.direction = "vertical",
    legend.spacing.x = unit(0.5, 'cm'),
    legend.spacing.y = unit(0.2, 'cm'),
    legend.key.size = unit(0.8, "lines"))
ggsave("Figures/Map_stop_ping.jpeg", p_stop,
       width = 10, height = 6.18, dpi = 600)



# ************************************************************
# **************** Map without major highways ****************
# Active pings
p_active_NOROAD = ggplot() +
  geom_sf(data = us_border, fill = NA, color = "grey10", size = 0.6) +
  # geom_sf(data = us_road,
  #         fill = NA, color = "grey20", size = 0.2) +
  geom_sf(data = ping_active1, aes(color = ping_quart),
          shape = 16, alpha = 0.5, size = 0.4) +
  scale_color_manual(values = RColorBrewer::brewer.pal(9, 'Reds')[4:8]) +
  coord_sf(crs = st_crs(crs_use)) +
  guides(color = guide_legend(title = "Number of pings",
                              override.aes = list(alpha = 1, size = 5))) +
  labs(x = NULL, y = NULL) +
  theme_map(
    legend.justification = c(1, 1),
    legend.position = c(0.2, 0.25),
    legend.direction = "vertical",
    legend.spacing.x = unit(0.5, 'cm'),
    legend.spacing.y = unit(0.2, 'cm'),
    legend.key.size = unit(0.8, "lines"))

ggsave("Figures/Map_active_ping_NOROAD.jpeg", p_active_NOROAD,
       width = 10, height = 6.18, dpi = 600)


# Inactive pings
p_stop_NOROAD = ggplot() +
  geom_sf(data = us_border, fill = NA, color = "grey10", size = 0.6) +
  # geom_sf(data = us_road,
  #         fill = NA, color = "grey20", size = 0.2) +
  geom_sf(data = ping_stop1, aes(color = ping_quart),
          shape = 16, alpha = 0.6, size = 0.7) +
  scale_color_manual(values = RColorBrewer::brewer.pal(9, 'Blues')[5:9]) +
  coord_sf(crs = st_crs(crs_use)) +
  guides(color = guide_legend(title = "Number of pings",
                              override.aes = list(alpha = 1, size = 5))) +
  labs(x = NULL, y = NULL) +
  theme_map(
    legend.justification = c(1, 1),
    legend.position = c(0.2, 0.25),
    legend.direction = "vertical",
    legend.spacing.x = unit(0.5, 'cm'),
    legend.spacing.y = unit(0.2, 'cm'),
    legend.key.size = unit(0.8, "lines"))
ggsave("Figures/Map_stop_ping_NOROAD.jpeg", p_stop_NOROAD,
       width = 10, height = 6.18, dpi = 600)

