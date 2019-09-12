pacman::p_load(data.table, dplyr, lubridate)


segment_0 = function(speed, threshold, time_diff) {
  ## Replace very long single points
  speed[time_diff >= threshold] <- 0
  ## First, replacing stretches of less than "threshold" consecutive 0 speeds by 1s
  r1 = rle(speed != 0)
  r1$values <- replicate(length(r1$values), 1)
  r1$values <- cumsum(r1$values)
  order_tmp <- inverse.rle(r1)
  dat_tmp1 <- data.table::data.table(speed, order_tmp, time_diff)
  dat_tmp2 <- dat_tmp1[,.(sumdiff = sum(time_diff)), by = order_tmp]
  r2 = rle(speed != 0)
  r2$values[r2$values == 0 & dat_tmp2$sumdiff < threshold] <- TRUE
  r2 <- inverse.rle(r2)
  r2 <- rle(r2)
  ## Then numbering consecutive stretches of non-zero values
  r2$values[r2$values] = cumsum(r2$values[r2$values])
  return(inverse.rle(r2))
}

(d = data.table(
  dtime = ymd_hms(c("2016-07-28T05:11:26Z", "2016-07-28T05:13:26Z",
                    "2016-07-28T05:21:26Z", "2016-07-28T08:11:26Z",
                    "2016-07-28T8:13:26Z", "2016-07-28T8:20:26Z",
                    "2016-07-28T12:13:26Z", "2016-07-28T16:19:26Z",
                    "2016-07-28T16:28:26Z", "2016-07-28T16:43:26Z")),
  speed = c(1:3, 0, 0, 0, 7:10),
  driver = c("z", "z", "z", "z", "z")
))


d %>%
  .[,diff := as.integer(difftime(dtime,
                                 shift(dtime, type = "lag",
                                       fill = 0),
                                 units = "mins")), driver] %>%
  .[,diff := {diff[1] = 0L; diff}, driver] %>%
  .[,trip_id := segment_0(speed = speed,
                          threshold = 30, time_diff = diff),
    driver] %>%
  .[]

