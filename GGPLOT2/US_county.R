pacman::p_load(tidycensus, tidyverse, viridis, sf)

us_county_income <- get_acs(geography = "county", variables = "B19013_001",
                            shift_geo = TRUE, geometry = TRUE,
                            key = '416a2650bf6183b42877bc48ff582d7ace1fdd77') %>%
  mutate(State = gsub('(.*)(, )(.*)', '\\3', NAME),
         County = gsub('(.*)(, )(.*)', '\\1', NAME),
         FIPS = GEOID,
         Income = estimate) %>%
  dplyr::select(State, County, FIPS, Income)
st_write(us_county_income, 'GGPLOT2/US_county_map/US_shape/US_county.shp',
         layer_options = "ENCODING=UTF-8", delete_layer = TRUE)


p_county = ggplot(us_county_income) +
  geom_sf(aes(fill = Income), color = NA) +
  coord_sf(datum = NA) +
  theme_minimal() +
  scale_fill_viridis_c(option = 'magma')
ggsave('GGPLOT2/US_county_map/US_county_map.png', p_county,
       width = 10, height = 6.18, dpi = 300)


us_state_income <- get_acs(geography = "state", variables = "B19013_001",
                            shift_geo = TRUE, geometry = TRUE,
                            key = '416a2650bf6183b42877bc48ff582d7ace1fdd77') %>%
  dplyr::select(GEOID = GEOID, State = NAME, income = estimate)
write_sf(us_state_income, 'GGPLOT2/US_county_map/US_shape/US_state.shp')

p_state = ggplot(us_state_income) +
  geom_sf(aes(fill = income), color = NA) +
  coord_sf(datum = NA) +
  theme_minimal() +
  scale_fill_viridis_c(option = 'magma')
ggsave('GGPLOT2/US_county_map/US_state_map.png', p_state,
       width = 10, height = 6.18, dpi = 300)
