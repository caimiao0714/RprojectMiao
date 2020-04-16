pacman::p_load(fst, dplyr, data.table, sf, ggplot2)
crs_use = 102003

us = sf::read_sf('map_file/tl_2017_us_state.shp') %>% 
  filter(!(STUSPS %in% c('AK', 'AS', 'GU', 'HI', 'MP', 'PR', 'VI'))) %>% 
  st_transform(crs = 4326)

ggplot() + 
  geom_sf(data = us) + 
  coord_sf(crs = st_crs(crs_use)) +
  theme_minimal()


# read in data matrix
d = read_fst("comb_dat/PM25.fst") %>% 
  as.data.table %>% 
  .[year == 2017]


pnts = d %>% 
  st_as_sf(coords = c('x', 'y'), crs = 4326) %>% 
  mutate(intersection = as.integer(st_intersects(geometry, us)),
         us_state = if_else(is.na(intersection), NA_character_, us$STUSPS[intersection]))


us_coord = d %>% 
  bind_cols(pnts %>% 
              st_drop_geometry() %>% 
              select(us_state)) %>% 
  filter(!is.na(us_state)) %>% 
  select(x, y, us_state) %>% 
  as.data.table %>% 
  setkey(x, y)
write_fst(us_coord, 'comb_dat/us_coord.fst')

us_coord = read_fst('comb_dat/us_coord.fst') %>% 
  as.data.table %>% 
  setkey(x, y)

# A function to get components data within us_coord
comp_us = function(comp = 'PM25', state = F){
  z = read_fst(paste0('comb_dat/', comp, '.fst')) %>% 
    as.data.table %>% 
    setkey(x, y) %>% 
    merge(us_coord, by = c('x', 'y'), all.x = TRUE) %>% 
    .[!is.na(us_state)] %>% 
    setkey(x, y, year)
  if(!state) z[,us_state := NULL]
  write_fst(z, paste0('comb_dat/us_', comp, '.fst'))
  return(z)
}

PM25 = comp_us('PM25', T)
BC = comp_us('BC', F)
DUST = comp_us('DUST', F)
NH4 = comp_us('NH4', F)
NO3 = comp_us('NO3', F)
OM = comp_us('OM', F)
SO4 = comp_us('SO4', F)
SS = comp_us('SS', F)


all = PM25 %>% 
  merge(BC, all = TRUE) %>% 
  merge(DUST, all = TRUE) %>% 
  merge(NH4, all = TRUE) %>% 
  merge(NO3, all = TRUE) %>% 
  merge(OM, all = TRUE) %>% 
  merge(SO4, all = TRUE) %>% 
  merge(SS, all = TRUE) 

fwrite(all, 'comb_dat/us_components_update.csv')