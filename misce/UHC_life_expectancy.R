require(tableone)
require(tidyverse)
vars <- c("Lifeexpectancy",  "CHICHE_SHA2011", "CHEGDP_SHA2011",
          "GGHE_DGDP_SHA2011", "PVT_DCHE_SHA2011",
          "OOPSCHE_SHA2011", "CFACHE_SHA2011", "Population", "GDP" )

tmp1 <- print(CreateContTable(vars, strata = "CountryIncomeGroup", data = f1),
              printToggle = FALSE) %>%
  as.data.frame() %>% select(c(2:4, 1))

tmp2 <-  print(CreateContTable(vars, data = f1),
               printToggle = FALSE) %>%
  as.data.frame()

tab1 <- cbind( tmp2, tmp1)

row.names(tab1) = c(
  'No of observations',
  'Life expectancy',
  'Compulsory health insurance as percent of CHE',
  'Current health expenditure as percent of GDP',
  'Government Health Expenditure as percent of GDP',
  'Private health expenditure as percent CHE',
  'Out-of-pocket payment as percent of CHE',
  'Compulsory financing arrangements as percent of CHE',
  'Population (millions)',
  'GDP'
)
names(tab1) = c("Overall", "Low", "Low-Mid", "Up-Mid", "High")


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
