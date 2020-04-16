pacman::p_load(dplyr, data.table, sf, fst, ggplot2, cowplot, patchwork)
crs_NAD83 = 102003

us = read_sf("tl_2017_us_state/tl_2017_us_state.shp") %>%
  filter(! (STUSPS %in% c("AK", "HI", "PR", "VI", "MP", "GU", "AS"))) %>%
  st_transform(crs = 4326)

all_pnts = fst::read_fst("PM25_state_09_13_17.fst") %>% as.data.table()


plt = function(var = "PM25", syear = 2009, lim = c(0, 20), fract = 0.01,
               color_plate = "magma", color_direction = -1, hasyear = FALSE,
               leftmost = FALSE){
  var1 = ifelse(var == "PM25", "PM2.5", var)

  # sample a fraction of rows
  pnts = all_pnts[year == syear, ] %>%
    .[sample(.N, .N*fract)] %>%
    st_as_sf(coords=c("x", "y"), crs = 4326)

  p1 = ggplot() +
    geom_sf(data = pnts,
            aes_string(fill = var, color = var),
            shape = 21, alpha = 0.8, size = 1) +
    viridis::scale_fill_viridis(option = color_plate,
                                limits = lim,
                                direction = color_direction) +
    viridis::scale_color_viridis(option = color_plate,
                                 limits = lim,
                                 direction = color_direction,
                                 guide = FALSE) +
    geom_sf(data = us,
            fill = NA,
            color = "white",
            size = 1) +
    coord_sf(crs = st_crs(crs_NAD83)) +
    ggthemes::theme_tufte() +
    theme(plot.title = element_text(hjust = 0.5, size = 30, face = "bold"),
          legend.title = element_blank(),
          legend.text  = element_text(size = 20),
          axis.title.x = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank())

  if(hasyear) p1 = p1 + ggtitle(syear)
  if(leftmost) p1 = p1 +
    ylab(var1) +
    theme(axis.title.y = element_text(angle = 0, hjust = 0, vjust = 0.5,
                                      size = 30, face = "bold"))

  return(p1)
}

PM25_09 = plt("PM25", 2009, c(0, 20), hasyear = T, leftmost = T)
PM25_13 = plt("PM25", 2013, c(0, 20), hasyear = T)
PM25_17 = plt("PM25", 2017, c(0, 20), hasyear = T)
PM25_all = PM25_09 + PM25_13 + PM25_17 & theme(legend.position = "right")
PM25_all = PM25_all + plot_layout(guides = "collect")


BC_09 = plt("BC", 2009, c(0, 3.5), leftmost = T)
BC_13 = plt("BC", 2013, c(0, 3.5))
BC_17 = plt("BC", 2017, c(0, 3.5))
BC_all = BC_09 + BC_13 + BC_17 & theme(legend.position = "right")
BC_all = BC_all + plot_layout(guides = "collect")

DUST_09 = plt("DUST", 2009, c(0, 5), leftmost = T)
DUST_13 = plt("DUST", 2013, c(0, 5))
DUST_17 = plt("DUST", 2017, c(0, 5))
DUST_all = DUST_09 + DUST_13 + DUST_17 & theme(legend.position = "right")
DUST_all = DUST_all + plot_layout(guides = "collect")

NH4_09 = plt("NH4", 2009, c(0, 2.2), leftmost = T)
NH4_13 = plt("NH4", 2013, c(0, 2.2))
NH4_17 = plt("NH4", 2017, c(0, 2.2))
NH4_all = NH4_09 + NH4_13 + NH4_17 & theme(legend.position = "right")
NH4_all = NH4_all + plot_layout(guides = "collect")

NO3_09 = plt("NO3", 2009, c(0, 5.5), leftmost = T)
NO3_13 = plt("NO3", 2013, c(0, 5.5))
NO3_17 = plt("NO3", 2017, c(0, 5.5))
NO3_all = NO3_09 + NO3_13 + NO3_17 & theme(legend.position = "right")
NO3_all = NO3_all + plot_layout(guides = "collect")

OM_09 = plt("OM", 2009, c(0, 12), leftmost = T)
OM_13 = plt("OM", 2013, c(0, 12))
OM_17 = plt("OM", 2017, c(0, 12))
OM_all = OM_09 + OM_13 + OM_17 & theme(legend.position = "right")
OM_all = OM_all + plot_layout(guides = "collect")

SO4_09 = plt("SO4", 2009, c(0, 4.5), leftmost = T)
SO4_13 = plt("SO4", 2013, c(0, 4.5))
SO4_17 = plt("SO4", 2017, c(0, 4.5))
SO4_all = SO4_09 + SO4_13 + SO4_17 & theme(legend.position = "right")
SO4_all = SO4_all + plot_layout(guides = "collect")

SS_09 = plt("SS", 2009, c(0, 4), leftmost = T)
SS_13 = plt("SS", 2013, c(0, 4))
SS_17 = plt("SS", 2017, c(0, 4))
SS_all = SS_09 + SS_13 + SS_17 & theme(legend.position = "right")
SS_all = SS_all + plot_layout(guides = "collect")


p_all = PM25_all/BC_all/DUST_all/NH4_all/NO3_all/OM_all/SO4_all/SS_all
ggsave("test_combine.png", p_all, width = 1*6*3, height = 0.618*6*8, dpi = 300)
ggsave("test_combine.tiff", p_all, width = 1*6*3, height = 0.618*6*8, dpi = 300)
ggsave("test_combine.jpeg", p_all, width = 1*6*3, height = 0.618*6*8, dpi = 300)
beepr::beep()



d = as.data.table(fst::read_fst('PM25_state.fst'))
d[,state := NULL]
fwrite(d, "PM2.5_components_intersect.csv")

for(i in 2009:2017){
  print(i)
  d %>%
    .[year == i] %>%
    fwrite(paste0("PM2.5_components_", i, ".csv"))
}



