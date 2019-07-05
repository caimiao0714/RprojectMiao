library(data.table)
library(lubridate)

# Example data
driver = rep(c("foo", "bar"), each = 10L)
dt = ymd_hm(c(
  "2015-05-27 07:11", "2015-05-27 07:25", "2015-05-27 07:35", "2015-05-27 07:42", "2015-05-27 07:53",
  "2015-05-27 08:09", "2015-05-27 08:23", "2015-05-27 08:39", "2015-05-27 08:52", "2015-05-27 09:12",
  "2015-05-27 16:12", "2015-05-27 16:31", "2015-05-27 16:39", "2015-05-27 16:53", "2015-05-27 17:29",
  "2015-05-27 17:41", "2015-05-27 17:58", "2015-05-27 18:09", "2015-05-27 18:23", "2015-05-27 18:42")
)
df = data.table(driver, dt)

# Code I've tried to separate the date and time
df[,diff := as.integer(difftime(dt, shift(dt, 1), units = "mins")),
   by = driver]
df[, diff := {diff[1] = 0L; diff}, driver]
df[,cum_mins := cumsum(diff), driver]
df[,cum_halfhour := round(cum_mins/30, 3), driver]
df[,flag0 := floor(round(cum_mins/30, 3)), driver]
df[,ind := flag0 - shift(flag0, fill = 0), driver]
df[, dif := cum_halfhour - floor(cum_halfhour) -
     (ceiling(shift(cum_halfhour, fill = 0)) - shift(cum_halfhour, fill = 0)), driver]
df[ind == 0, dif := NA]
df[dif < 0, flag0 := flag0 - 1]
df

## 1st answer
library(data.table)
driver = rep(c("foo", "bar"), each = 10L)
dt = as.POSIXct(c(
  "2015-05-27 07:11", "2015-05-27 07:25", "2015-05-27 07:35",
  "2015-05-27 07:42", "2015-05-27 07:53",
  "2015-05-27 08:09", "2015-05-27 08:23", "2015-05-27 08:39",
  "2015-05-27 08:52", "2015-05-27 09:12",
  "2015-05-27 16:12", "2015-05-27 16:31", "2015-05-27 16:39",
  "2015-05-27 16:53", "2015-05-27 17:29",
  "2015-05-27 17:41", "2015-05-27 17:58", "2015-05-27 18:09",
  "2015-05-27 18:23", "2015-05-27 18:42")
  , format = "%F %H:%M", tz = "America/Chicago")

df = data.table(driver, dt)
df[, cum_halfhour := round(as.integer(difftime(dt, min(dt),
                                              units = "mins"))/30,
                           3),
   by = .(driver)]
df[,half_points := as.integer(floor(cum_halfhour))]

df[,trans := 0L]
df[,trans := {trans[c(1,.N)] = 1L; trans}, by = c("driver", "half_points")]
df[,trans := {trans[1] = 0L; trans}, by = driver]

df[trans == 0L, ben := NA_integer_]
df[trans == 1L, ben := half_points]





setkey(df,driver,cum_halfhour)
setkey(Lookup,driver,join_half_points)

df[,half_point := Lookup[df,half_points, roll = "nearest"]]

## Create a flag using `data.table::rleid` for each driver
df[,flag := rleid(half_point) - 1L, by = .(driver)]

d = data.table(driver, dt)
d[,dt_epoch := as.integer(dt)]
d[,cum_halfhour := round((dt_epoch - min(dt_epoch))/1800,3), by = .(driver)]
d[,r05h := round(cum_halfhour)]
d[,f05h := floor(cum_halfhour)]

d[,trans := 0]
d[,trans := {trans[c(1,.N)] = 1L; trans}, by = c("driver", "f05h")]
d[,trans := {trans[1] = 0L; trans}, by = driver]
d




