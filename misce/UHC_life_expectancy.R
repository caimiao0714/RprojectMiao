require(tableone)
require(tidyverse)
vars <- c("Lifeexpectancy",  "CHICHE_SHA2011")

d1 = CreateContTable(vars = 
  c('prep_inten', 'prep_prob', 'wind_speed', 'visibility'), data = d) %>% 
  print(printToggle = FALSE) %>% 
  as.data.frame() %>% 
  tibble::rownames_to_column() %>% 
  mutate_if(is.factor, as.character)
d2 = CreateCatTable(vars = 
  c('weekend', 'holiday', 'hour_of_day'), data = d) %>% 
  print(printToggle = FALSE) %>% 
  as.data.frame() %>% 
  tibble::rownames_to_column() %>% 
  mutate_if(is.factor, as.character)


windowsFonts(Times=windowsFont("Times New Roman"))
f1 %>%
  filter(!is.na(CountryIncomeGroup)) %>%
  mutate(CountryIncomeGroup = ifelse(CountryIncomeGroup == 'Hi',
                                     'High', CountryIncomeGroup)) %>%
  mutate(CountryIncomeGroup = factor(CountryIncomeGroup,
                                     levels = c('Low', 'Low-Mid', 'Up-Mid', 'High'))) %>%
  ggplot(aes(x = Year, y = Lifeexpectancy,
             group = CountryName, color = CountryIncomeGroup)) +
  geom_line(alpha = 0.5, size = 0.1) +
  theme_bw() + ylab('Life expectancy in each country') +
  scale_x_continuous("Year", labels = as.character(2000:2016), breaks = 2000:2016)+
  theme(legend.justification = c(1, 1), legend.position = c(0.95, 0.1),
        legend.background = element_rect(fill=alpha('white', 0.8)),
        legend.direction="horizontal", text=element_text(family="Times"))+
  guides(color=guide_legend(title="Income group",
                            override.aes = list(alpha = 1, size = 2)))
