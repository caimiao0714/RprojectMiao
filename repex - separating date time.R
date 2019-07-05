library(data.table)
library(lubridate)

# Example data
ex = function(){
  driver = rep(c("foo", "bar"), each = 10L)
  dt = ymd_hm(c(
    "2015-05-27 07:11", "2015-05-27 07:25", "2015-05-27 07:35", "2015-05-27 07:42", "2015-05-27 07:53",
    "2015-05-27 08:09", "2015-05-27 08:23", "2015-05-27 08:39", "2015-05-27 08:52", "2015-05-27 09:12",
    "2015-05-27 16:12", "2015-05-27 16:31", "2015-05-27 16:39", "2015-05-27 16:53", "2015-05-27 17:29",
    "2015-05-27 17:41", "2015-05-27 17:58", "2015-05-27 18:09", "2015-05-27 18:23", "2015-05-27 18:43")
  )
  df = data.table(driver, dt)
  return(df)
}


# 1. Solution 1: floor half an hour
df = ex()
df[,diff := as.integer(difftime(dt, shift(dt, 1),
                                units = "mins")),
   by = driver]
df[, diff := {diff[1] = 0L; diff}, driver]
df[,cum_mins := cumsum(diff), driver]
df[,cum_halfhour := round(cum_mins/30, 3), driver]
df[,flag0 := floor(round(cum_mins/30, 3)), driver]

# 2. Solution 2: Round half an hour to the nearest one
df = ex()
# 2a. the same as soltion 1
df[,diff := as.integer(difftime(dt, shift(dt, 1),
                                units = "mins")),
   by = driver]
df[, diff := {diff[1] = 0L; diff}, driver]
df[,cum_mins := cumsum(diff), driver]
df[,cum_halfhour := round(cum_mins/30, 3), driver]
df[,flag0 := floor(round(cum_mins/30, 3)), driver]
# 2b. further optimize the range
df[,ind := flag0 - shift(flag0, fill = 0), driver]
df[, dif := cum_halfhour - floor(cum_halfhour) -
     (ceiling(shift(cum_halfhour, fill = 0)) - shift(cum_halfhour, fill = 0)), driver]
df[ind == 0, dif := NA]
df[dif < 0, flag0 := flag0 - 1]
df = df[,.(driver, dt, cum_mins, flag0)]
df

# 3. Solution 3: Global half an hour
df = ex()
df[,diff := as.integer(difftime(dt, shift(dt, 1),
                                units = "mins")),
   by = driver]
df[, diff := {diff[1] = 0L; diff}, driver]
df[,cum_mins := cumsum(diff), driver]
df[,cum_halfhour := round(cum_mins/30, 3), driver]
df[,flag0 := floor(round(cum_mins/30, 3)), driver]

t1 = df[, .SD[c(1)], by = c("driver")]
t2 = df[, .SD[c(.N)], by = c("driver", "flag0")]
df1 = rbindlist(list(t1, t2), TRUE)
df1 = df1[order(driver, dt),]
df1[,add1 := 0:(.N-1), by = driver]
df1[,dt1 := dt[1] + add1*30*60, driver]
df1[,endtime := shift(dt1, type = "lead"), by = driver]
df1[,endtime := {endtime[.N - 1] = dt[.N]; endtime}, by = driver]
df1 = df1[!is.na(endtime), ]
df1[, pingid := .I]
df1 = df1[, .(pingid, driver, dt1, endtime, cum_mins)]
df1
