# devtools::install_github("gadenbuie/ggweekly")
library(ggweekly)

project_days <- dplyr::tribble(
  ~day,             ~label,    ~color,     ~fill,
  "2019-12-26",         "Yangzhou", "#02307a", "#02307a",
  "2019-12-27",         "Yangzhou", "#02307a", "#02307a",
  "2019-12-28",         "Yangzhou", "#02307a", "#02307a",
  "2019-12-29",         "Yangzhou", "#02307a", "#02307a",
  "2019-12-27",         "                   Sun Yat-sen", "#bf006c", "#bf006c",
  "2019-12-28",         "                   Sun Yat-sen", "#bf006c", "#bf006c",
)

g2019 = ggweek_planner(
  start_day = "2019-12-02",
  end_day = "2020-1-30",
  highlight_days = project_days
) +
  ggplot2::ggtitle("Dec, 2019 - Jan, 2020")

g2019

ggplot2::ggsave(
  file = "2019-full-year.pdf",
  plot = g2019,
  width = 11, height = 8.5
)
