pacman::p_load(dplyr, ggplot2, ggrepel)
ND = readRDS("Plot - ggplot2/nd.Rds")

nd %>%
  ggplot(aes(x = year, y = hr_update,
             group = variables, color = variables)) +
  geom_line() +
  labs(y = "Time-varying HRs") +
  geom_label_repel(data = filter(nd, year == 2008, hr_update >= 2),
                   aes(label = label),
                   nudge_x = -10.5 - filter(nd, year == 2008, hr_update >= 2) %>%
                     pull(variables) %>% nchar(),
                   nudge_y = 1,
                   segment.size = 0.2,
                   #vjust = 4,
                   na.rm = TRUE) +
  scale_colour_discrete(guide = 'none')+
  scale_x_continuous(breaks = 2008:2018, labels = 2008:2018,
                     limits = c(2006,2018))+
  theme_classic()

ggsave("Plot - ggplot2/label_lines_using_geom_label_repel.png")
