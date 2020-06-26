pacman::p_load(dplyr, data.table, sf, tigris, lubridate, tmap,spdep)
# read and filter MO COVID-19 data
d = fread("misce/MO-COVID-19/dailyupdate.csv") %>%
  .[state == 'Missouri',] %>%
  .[,date := ymd(date)] %>%
  setkey(date, county)
SES = fread("misce/MO-COVID-19/MO_SES.csv")

# get MO county boundaries for MO
MO = tigris::counties(state = 'MO', year = 2018, class = 'sf') %>%
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
    tm_layout(main.title = paste0("Covid-19 cases, ",
                                  format(ymd(a_date), '%b %d, %Y')),
                           main.title.position =c("left","bottom"))+
    tm_legend(position=c("right", "top"), legend.bg.alpha=0,
              legend.text.size=0.5,bg.color="grey100")
  return(p)
}

mapMO('2020-5-6')
mapMO('2020-5-7')
mapMO('2020-5-8')

##Merged dataset for analysis
M = MO %>%
  left_join(SES,by=c('FPS_code'='FIPS')) %>%
  left_join(d, by = c('FPS_code' = 'fips')) %>%
  mutate(cases = if_else(is.na(cases), 0L, cases))

##Weight
sp_M <- as_Spatial(M)
M.sids.nb = poly2nb( M )
M.sids.net = nb2lines( M.sids.nb , coords=coordinates(sp_M) )
M_weight = spdep::nb2listw(M.sids.nb, style = 'W', zero.policy = TRUE)
