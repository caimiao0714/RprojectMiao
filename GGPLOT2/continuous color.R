pacman::p_load(ggplot2, RColorBrewer, dplyr)

head(mtcars)

mtcars %>%
  ggplot(aes(x = hp, y = mpg, color = drat)) +
  geom_point(size = 5) +
  scale_color_continuous(low = '#fcbba1', high = '#bd0026') +
  theme_bw()


