pacman::p_load(fst, data.table, ggcorrplot, magrittr)

d = as.data.table(read_fst("PM25_state.fst"))

z = d %>%
  .[,.(PM25, BC, DUST, NH4, NO3, OM, SO4, SS)] %>%
  cor() %>%
  round(2)

p1 = ggcorrplot(z,
           #hc.order = TRUE,
           type = "lower",
           lab = TRUE,
           outline.col = "black")


d1 = melt(d[,.(PM25, BC, DUST, NH4, NO3, OM, SO4, SS)],
          measure.vars = c('PM25', 'BC', 'DUST', 'NH4', 'NO3', 'OM', 'SO4', 'SS'))

p2  = ggplot(d, aes(x = )) +
  geom_boxplot()

ggsave('figures/test.png', p)
ggsave('figures/test.png', p)
ggsave('figures/test.png', p)