pacman::p_load(dplyr, ggplot2, lubridate)
set.seed(123)

ping_diff = 1*60 # 1 minutes
shift_length = 15*60*60/ping_diff # 14 hours
tdiff = rpois(shift_length, ping_diff)
shift_start = ymd_hms("20150521 06:21:30")
ping_time = shift_start + cumsum(tdiff)
ping_speed = round(rnorm(length(tdiff), 62, 1.5))

trip = tibble::tibble(start_time = ymd_hms(c("20150521 06:31:30",
                                             "20150521 13:00:30",
                                             "20150521 18:31:30")),
                      end_time = c(ymd_hms("20150521 10:39:30"),
                                   ymd_hms("20150521 16:50:30"),
                                   ping_time[length(ping_time)])) %>%
  mutate(trip_length = as.integer(difftime(end_time, start_time, units = "secs"))) %>%
  mutate(median_time = start_time + trip_length/2) %>%
  mutate(n_interval = ceiling(trip_length/(30*60)),
         trip_id = 1:n())

median_shift = trip$start_time[1] +
  as.integer(difftime(trip$end_time[nrow(trip)], trip$start_time[1], units = "secs"))/2

int30 = trip %>%
  select(-trip_length, -median_time) %>%
  tidyr::uncount(n_interval, .remove = FALSE, .id = "interval_id") %>%
  mutate(start_time = start_time + 30*60*(interval_id - 1)) %>%
  group_by(trip_id) %>%
  mutate(end_time = case_when(row_number() != n() ~ lead(start_time, 1),
                              TRUE ~ end_time)) %>%
  ungroup()

d_int30 = int30 %>%
  select(trip_time = end_time) %>%
  bind_rows(select(trip, trip_time = start_time)) %>%
  arrange(trip_time)

d = tibble::tibble(ping_time, ping_speed) %>%
  mutate(ping_speed = case_when(
    ping_time <= trip$start_time[1] ~ 0,
    ping_time >= trip$end_time[1] &
      ping_time <= ymd_hms("20150521 13:00:30") ~ 0,
    ping_time >= ymd_hms("20150521 16:31:30") &
      ping_time <= ymd_hms("20150521 18:31:30") ~ 0,
    row_number() >= n() - 5 ~ 0,
    TRUE ~ ping_speed))

d %>%
  ggplot(aes(x = ping_time, y = ping_speed)) +
  geom_point(color = "blue", size = 0.8) + geom_line() +
  ylim(c(-17.5, 70)) + theme_test() +
  geom_segment(data = d, aes(x = ping_time[1], xend = ping_time[nrow(d)],
                             y = -3, yend = -3),
             arrow = arrow(length = unit(0.2, "cm")),
             lineend = 'butt', size = 0.8, color = "red") +
  geom_text(aes(x = median_shift, y = -4.8,
                             label = "Shift"), color = "red") +
  geom_segment(data = trip, aes(x = start_time, xend = end_time,
                                y = -9, yend = -9),
               arrow = arrow(length = unit(0.2, "cm")),
               lineend = 'butt', size = 0.8, color = "#7b3294") +
  geom_text(data = trip, aes(x = median_time,
                             y = rep(-10.8, nrow(trip)),
                             label = paste("Trip", 1:nrow(trip), " ")),
            color = "#7b3294") +
  geom_point(data = d_int30, aes(x = trip_time, y = -15),
             size = 2, color = "#008837", shape = 124) +
  geom_segment(data = trip, aes(x = start_time, xend = end_time,
                                y = -15, yend = -15),
               arrow = arrow(length = unit(0.2, "cm")),
               lineend = 'butt', size = 0.8, color = "#008837") +
  geom_text(data = trip, aes(x = median_time,
                             y = rep(-17.5, nrow(trip)),
                             label = rep("30 minutes intervals", nrow(trip))),
            color = "#008837") +
  scale_x_datetime(breaks = sort(c(trip$start_time, trip$end_time)),
                   labels = scales::date_format("%H:%M")) +
  labs(x = "ping time", y = "ping speed")

ggsave("NSF - truck naturalistic driving - repex/ping_trip_shift_aggregation.pdf",
       width = 10, height = 6.18)
