pacman::p_load(dplyr, ggplot2, lubridate)
set.seed(123)

ping_diff = 1.5*60 # 1.5 minutes
shift_length = 15*60*60/ping_diff # 14 hours
tdiff = rpois(shift_length, 100)
shift_start = ymd_hms("20150521 06:21:30")
ping_time = shift_start + cumsum(tdiff)


ping_speed = rnorm(length(tdiff), 60, 3)


d = tibble::tibble(ping_time, ping_speed) %>%
  mutate(ping_speed = case_when(
    ping_time <= ymd_hms("20150521 06:31:30") ~ 0,
    ping_time >= ymd_hms("20150521 10:31:30") &
      ping_time <= ymd_hms("20150521 13:00:30") ~ 0,
    ping_time >= ymd_hms("20150521 16:31:30") &
      ping_time <= ymd_hms("20150521 18:31:30") ~ 0,
    row_number() >= n() - 5 ~ 0,
    TRUE ~ ping_speed))

d %>%
  ggplot(aes(x = ping_time, y = ping_speed)) +
  geom_point(color = "blue") + geom_line() +
  ylim(c(-10, 75)) + theme_classic()
