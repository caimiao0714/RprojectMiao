pacman::p_load(dplyr, data.table, sf, ggplot2, cowplot, patchwork)
crs_NAD83 = 102003

us = read_sf("tl_2017_us_state/tl_2017_us_state.shp") %>%
  filter(! (STUSPS %in% c("AK", "HI", "PR", "VI", "MP", "GU", "AS"))) %>%
  st_transform(crs = 4326)

all_pnts = fst::read_fst("PM25_state_09_13_17.fst") %>% as.data.table()


# ------------ test plot -----------------------
pnts = all_pnts[year == 2013, ] %>%
  .[sample(.N, .N*0.0002)] %>%
  st_as_sf(coords=c("x", "y"), crs = 4326)

p = ggplot() +
  geom_sf(data = pnts,
          aes(fill = PM25, color = PM25),
          shape = 21, alpha = 0.8, size = 1) +
  viridis::scale_fill_viridis(option = "magma",
                              limits = c(0, 20)) +
  viridis::scale_color_viridis(option = "magma",
                               limits = c(0, 20),
                               guide = FALSE) +
  geom_sf(data = us,
          fill = NA,
          color = "white",
          size = 1.2) +
  coord_sf(crs = st_crs(crs_NAD83)) +
  theme_void() +
  ggtitle("PM2.5, 2013") +
  theme(plot.title = element_text(hjust = 0.5, size = 32, face = "bold"),
        legend.position = c(0.98, 0.5),
        legend.title = element_blank(),
        legend.text  = element_text(size = 20))
ggsave("test.png", p, width = 10, height = 6.18)
# ------------ test plot -----------------------



plt = function(var = "PM25", syear = 2009, lim = c(0, 20), fract = 0.0001,
               color_plate = "magma", color_direction = 1){
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
    theme_void() +
    ggtitle(paste0(var1, ", ", syear)) +
    theme(plot.title = element_text(hjust = 0.5, size = 32, face = "bold"),
          legend.position = c(0.98, 0.5),
          legend.title = element_blank(),
          legend.text  = element_text(size = 20))

  return(p1)
}


fig_all = function(col_p = "magma", col_d = 1){
  PM25_09 = plt("PM25", 2009, c(0, 20), color_plate = col_p, color_direction = col_d)
  BC_09 = plt("BC", 2009, c(0, 3.5), color_plate = col_p, color_direction = col_d)
  DUST_09 = plt("DUST", 2009, c(0, 5), color_plate = col_p, color_direction = col_d)
  NH4_09 = plt("NH4", 2009, c(0, 2.2), color_plate = col_p, color_direction = col_d)
  NO3_09 = plt("NO3", 2009, c(0, 5.5), color_plate = col_p, color_direction = col_d)
  OM_09 = plt("OM", 2009, c(0, 12), color_plate = col_p, color_direction = col_d)
  SO4_09 = plt("SO4", 2009, c(0, 4.5), color_plate = col_p, color_direction = col_d)
  SS_09 = plt("SS", 2009, c(0, 4), color_plate = col_p, color_direction = col_d)


  PM25_13 = plt("PM25", 2013, c(0, 20), color_plate = col_p, color_direction = col_d)
  BC_13 = plt("BC", 2013, c(0, 3.5), color_plate = col_p, color_direction = col_d)
  DUST_13 = plt("DUST", 2013, c(0, 5), color_plate = col_p, color_direction = col_d)
  NH4_13 = plt("NH4", 2013, c(0, 2.2), color_plate = col_p, color_direction = col_d)
  NO3_13 = plt("NO3", 2013, c(0, 5.5), color_plate = col_p, color_direction = col_d)
  OM_13 = plt("OM", 2013, c(0, 12), color_plate = col_p, color_direction = col_d)
  SO4_13 = plt("SO4", 2013, c(0, 4.5), color_plate = col_p, color_direction = col_d)
  SS_13 = plt("SS", 2013, c(0, 4), color_plate = col_p, color_direction = col_d)



  PM25_17 = plt("PM25", 2017, c(0, 20), color_plate = col_p, color_direction = col_d)
  BC_17 = plt("BC", 2017, c(0, 3.5), color_plate = col_p, color_direction = col_d)
  DUST_17 = plt("DUST", 2017, c(0, 5), color_plate = col_p, color_direction = col_d)
  NH4_17 = plt("NH4", 2017, c(0, 2.2), color_plate = col_p, color_direction = col_d)
  NO3_17 = plt("NO3", 2017, c(0, 5.5), color_plate = col_p, color_direction = col_d)
  OM_17 = plt("OM", 2017, c(0, 12), color_plate = col_p, color_direction = col_d)
  SO4_17 = plt("SO4", 2017, c(0, 4.5), color_plate = col_p, color_direction = col_d)
  SS_17 = plt("SS", 2017, c(0, 4), color_plate = col_p, color_direction = col_d)

  all_8_cols = plot_grid(
    PM25_09, BC_09, DUST_09, NH4_09, NO3_09, OM_09, SO4_09, SS_09,
    PM25_13, BC_13, DUST_13, NH4_13, NO3_13, OM_13, SO4_13, SS_13,
    PM25_17, BC_17, DUST_17, NH4_17, NO3_17, OM_17, SO4_17, SS_17,
    ncol = 8
  )
  ggsave(paste0("all_8_cols", col_p, col_d, ".png"),
         all_8_cols, width = 1*6*8, height = 0.618*6*3, dpi = 300)


  all_3_cols = plot_grid(
    PM25_09, PM25_13, PM25_17,
    BC_09, BC_13, BC_17,
    DUST_09, DUST_13, DUST_17,
    NH4_09, NH4_13, NH4_17,
    NO3_09, NO3_13, NO3_17,
    OM_09, OM_13, OM_17,
    SO4_09, SO4_13, SO4_17,
    SS_09, SS_13, SS_17,
    ncol = 3
  )
  ggsave(paste0("all_3_cols", col_p, col_d, ".png"),
         all_3_cols, width = 1*6*3, height = 0.618*6*8, dpi = 300)
}



fig_all(col_p = "magma", col_d = 1)
fig_all(col_p = "magma", col_d = -1)
fig_all(col_p = "plasma", col_d = 1)
fig_all(col_p = "plasma", col_d = -1)
fig_all(col_p = "inferno", col_d = 1)
fig_all(col_p = "inferno", col_d = -1)
fig_all(col_p = "viridis", col_d = 1)
fig_all(col_p = "viridis", col_d = -1)
fig_all(col_p = "cividis", col_d = 1)
fig_all(col_p = "cividis", col_d = -1)





PM25_09 = plt("PM25", 2009, c(0, 20), color_plate = "magma", color_direction = -1)
PM25_13 = plt("PM25", 2013, c(0, 20), color_plate = "magma", color_direction = -1)
PM25_17 = plt("PM25", 2017, c(0, 20), color_plate = "magma", color_direction = -1)


p_all = PM25_09 + PM25_13 + PM25_17 & theme(legend.position = c(0.98, 0.5))
p_all = p_all + plot_layout(guides = "collect")
#ggsave("test_combine.png", p_all, width = 1*6*3, height = 0.618*6*1, dpi = 300)
