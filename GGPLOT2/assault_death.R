library(tidyverse)

d = read_csv(RCurl::getURL("https://raw.githubusercontent.com/kjhealy/assault-deaths/master/data/oecd-assault-series-per-100k-standardized-to-2015.csv")) %>%
  gather(key = Year, value = "assault_death", -Country) %>%
  na.omit() %>%
  filter(!(Country %in% c("Estonia", "Mexico"))) %>%
  mutate(Country_Cat = ifelse(Country == "United States",
                          "United States", "Other OECD"))

p = d %>%
  ggplot(aes(Year, assault_death, group = Country,
             color = Country_Cat)) +
  geom_point() + geom_smooth(aes(fill = Country_Cat))+
  scale_x_discrete(breaks = seq(1960, 2015, 10)) +
  theme_bw() +
  labs(y = "Assault Deaths per 100k population",
       caption = "Data: OECD. Exclude Estonia and Mexico",
       colour = "Country", fill = "Country")
p

ggsave("Plot - GGPLOT2/US_OECD_assault_death.png", p, width = 10, height = 6.18)