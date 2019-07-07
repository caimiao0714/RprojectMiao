library(data.table)
library(lubridate)

# Example data
ex = function(){
  driver = rep(c("foo", "bar"), each = 10L)
  ping_time = ymd_hm(c(
    "2015-05-27 07:11", "2015-05-27 07:25", "2015-05-27 07:35", "2015-05-27 07:42", "2015-05-27 07:53",
    "2015-05-27 08:09", "2015-05-27 08:23", "2015-05-27 08:39", "2015-05-27 08:52", "2015-05-27 09:12",
    "2015-05-27 16:12", "2015-05-27 16:31", "2015-05-27 16:39", "2015-05-27 16:53", "2015-05-27 17:29",
    "2015-05-27 17:41", "2015-05-27 17:58", "2015-05-27 18:09", "2015-05-27 18:23", "2015-05-27 18:43")
  )
  df = data.table(driver, ping_time)
  return(df)
}

# --------------------------------- #
# 1. Solution 1: floor half an hour #
# --------------------------------- #
ping_df = ex()
ping_df[,diff := as.integer(difftime(ping_time, shift(ping_time, 1),
                                     units = "mins")),
        by = driver]
ping_df[, diff := {diff[1] = 0L; diff}, driver]
ping_df[,cum_mins := cumsum(diff), driver]
ping_df[,cum_halfhour := round(cum_mins/30, 3), driver]
ping_df[,flag0 := floor(round(cum_mins/30, 3)), driver]


# ---------------------------------------------------- #
# 2. Solution 2: Round half an hour to the nearest one #
# ---------------------------------------------------- #
ping_df = ex()
# 2a. the same as soltion 1
ping_df[,diff := as.integer(difftime(ping_time, shift(ping_time, 1),
                                     units = "mins")),
        by = driver]
ping_df[, diff := {diff[1] = 0L; diff}, driver]
ping_df[,cum_mins := cumsum(diff), driver]
ping_df[,cum_halfhour := round(cum_mins/30, 3), driver]
ping_df[,flag0 := floor(round(cum_mins/30, 3)), driver]
# 2b. further optimize the range
ping_df[,ind := flag0 - shift(flag0, fill = 0), driver]
ping_df[, dif := cum_halfhour - floor(cum_halfhour) -
          (ceiling(shift(cum_halfhour, fill = 0)) - shift(cum_halfhour, fill = 0)), driver]
ping_df[ind == 0, dif := NA]
ping_df[dif < 0, flag0 := flag0 - 1]
ping_df = ping_df[,.(driver, ping_time, cum_mins, flag0)]
setkey(ping_df, driver, ping_time)
ping_df[,ping_id := .I]
#


# ---------------------------------- #
# 3. Solution 3: Global half an hour #
# ---------------------------------- #
ping_df = ex()
ping_df[,diff := as.integer(difftime(ping_time, shift(ping_time, 1),
                                     units = "mins")),
        by = driver]
ping_df[, diff := {diff[1] = 0L; diff}, driver]
ping_df[,cum_mins := cumsum(diff), driver]
ping_df[,cum_halfhour := round(cum_mins/30, 3), driver]
ping_df[,flag0 := floor(round(cum_mins/30, 3)), driver]
setkey(ping_df, driver, ping_time)
ping_df[,ping_id := .I]

# construct trip_df
t1 = ping_df[, .SD[c(1)], by = c("driver")]
t2 = ping_df[, .SD[c(.N)], by = c("driver", "flag0")]
trip_df = rbindlist(list(t1, t2), TRUE)
trip_df = trip_df[order(driver, ping_time),]
trip_df[,add1 := 0:(.N-1), by = driver]
trip_df[,start_time := ping_time[1] + add1*30*60, driver]
trip_df[,end_time := shift(start_time, type = "lead"), by = driver]
trip_df[,end_time := {end_time[.N - 1] = ping_time[.N]; end_time}, by = driver]
trip_df = trip_df[!is.na(end_time), ]
trip_df[, trip_id := .I]
trip_df = trip_df[, .(trip_id, driver, start_time, end_time, cum_mins)]
trip_df

# merge trip_id back to ping data
setkey(trip_df, start_time, end_time)
ping_df[,dummy := ping_time]
pitr_df = foverlaps(ping_df, trip_df,
                 by.x = c("ping_time", "dummy"))[, dummy := NULL][
                   ,.(ping_id, trip_id, driver, start_time, end_time, ping_time)]
pitr_df
