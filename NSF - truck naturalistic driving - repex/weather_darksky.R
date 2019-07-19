require(purrr)
require(darksky)
Sys.setenv(DARKSKY_API_KEY = myDarkSkyAPIkey) 
# you need to register on the darksky to get your own "myDarkSkyAPIkey"

dat = structure(list(
  latitude = c(41.3473127, 41.8189037, 32.8258477, 40.6776808, 40.2366043), 
  longitude = c(-74.2850908, -73.0835104, -97.0306677, -75.1450753, -76.9367494), 
  time = structure(c(1453101738, 1437508088, 1436195038, 1435243088, 1454270680), 
                   class = c("POSIXct", "POSIXt"), tzone = "UTC")), 
  row.names = c(NA, -5L), class = "data.frame"
)
weather_dat <- pmap(
  list(dat$latitude, dat$longitude, dat$time),
  get_forecast_for)