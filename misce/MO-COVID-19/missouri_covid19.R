pacman::p_load(dplyr, data.table, sf, tigris, lubridate, tmap)
# read and filter MO COVID-19 data
d = fread("misce/MO-COVID-19/dailyupdate.csv") %>%
  .[state == 'Missouri',] %>%
  .[,date := ymd(date)] %>%
  setkey(date, county)

# get MO county boundaries for MO
MO = tigris::counties(state = 'MO', year = 2018) %>%
  st_as_sf() %>%
  mutate(FPS_code = as.numeric(paste0(STATEFP, COUNTYFP))) %>%
  select(FPS_code, county_name = NAME)

# test merging
mapMO = function(a_date){
  p = MO %>%
    left_join(d[date == ymd(a_date),], by = c('FPS_code' = 'fips')) %>%
    mutate(cases = if_else(is.na(cases), 0L, cases)) %>%
    tm_shape() +
    tm_polygons("cases", style="fixed",
                breaks=c(0,10,100,500,1000,2000,3700)) +
    tm_layout(main.title = paste0("Number of confirmed COVID-19 in Missouri, ",
                             format(ymd(a_date), '%b %d, %Y')),
              main.title.position = "center")
  return(p)
}

mapMO('2020-5-6')
mapMO('2020-5-7')
mapMO('2020-5-8')











