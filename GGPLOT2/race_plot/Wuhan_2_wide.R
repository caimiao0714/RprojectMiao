pacman::p_load(dplyr, readr, lubridate, tidyr)

d = read_csv("race_plot/Wuhan_20200201.csv") %>%
  select(1:3) %>%
  `colnames<-`(c("Province", "Date", "Diagnosed")) %>%
  mutate(Date = ymd(Date)) %>%
  pivot_wider(id_cols = Province,
              names_from = Date,
              values_from = Diagnosed)


write_csv(d, "race_plot/zzz.csv")
