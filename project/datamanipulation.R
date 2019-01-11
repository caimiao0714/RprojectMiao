Sys.setlocale("LC_CTYPE", "chinese")
load("I1317.Rdata")
load("weather.Rdata")
require(tidyverse)

SXtemp = weather %>%
  as_tibble() %>%
  rename(date = ymd,
         tmax = bWendu,
         tmin = yWendu) %>%
  mutate(date = lubridate::ymd(date),
         tmax = as.numeric(gsub("([0-9]+).*$", "\\1", tmax)),
         tmin = as.numeric(gsub("([0-9]+).*$", "\\1", tmin)),
         tmed = (tmax + tmin)/2) %>%
  mutate(tmax = weathermetrics::celsius.to.fahrenheit(tmax),
         tmed = weathermetrics::celsius.to.fahrenheit(tmed),
         tmin = weathermetrics::celsius.to.fahrenheit(tmin),
         tvarv = tmax - tmin,
         diff1 = abs(tmed - lag(tmed, n =1, default = tmed[1])),
         tvarh = RcppRoll::roll_sum(diff1, n = 7, fill = 0))


library('pinyin')
mypy = pydic(method = 'toneless')
# a function to run `py()` on several vectors
conv_py = function(data, var_name){
  for(i in var_name){
    data[[i]] = map(data[[i]], function(x){py(x, dic = mypy)}) %>%
      gsub("_", "", .) %>%
      unlist()
  }
  return(data)
}


SXtemp = conv_py(SXtemp, c("city", "county"))


save(SXtemp, file = "SXtemp.Rdata")
