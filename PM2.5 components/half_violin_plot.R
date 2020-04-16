pacman::p_load(data.table, dplyr, ggplot2, ggcorrplot,
               cowplot, patchwork, ggthemes, see)
d = as.data.table(fst::read_fst("PM25_state.fst"))

# correlation matrix
cor_mat = d %>%
  .[,.(PM25, BC, DUST, NH4, NO3, OM, SO4, SS)] %>%
  cor() %>%
  round(2)

p1 = ggcorrplot(cor_mat,
                #hc.order = TRUE,
                type = "lower",
                lab = TRUE,
                ggtheme = ggthemes::theme_hc,
                show.legend = F,
                outline.col = "black",
                tl.srt = 0) +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) +
  theme(axis.text.y = element_text(size=12, hjust = 1, vjust = 0.5),
        axis.text.x = element_text(size=12, hjust = 0.5, vjust = 1),
        axis.ticks = element_blank())
ggsave("Exposure_correlation.png", p1,
       width = 5, height = 5, dpi = 500)

# violin plot
d1 = melt(d[PM25 < 15 & BC < 1.5 & DUST < 1.9 &
              NH4 < 1.9 & NO3 < 3 & OM < 7 & SS < 0.75,
            .(year, PM2.5 = PM25, BC, DUST,
              NH4, NO3, OM, SO4, SS)],
          id.vars = "year",
          measure.vars = c('PM2.5', 'BC', 'DUST', 'NH4',
                           'NO3', 'OM', 'SO4', 'SS'),
          variable.name = "Component",
          value.name = "ug/m2")

p_violin = d1 %>%
  ggplot(aes(factor(year, levels = 2017:2009), `ug/m2`, fill = Component)) +
  geom_violinhalf(trim = FALSE, scale = "width",adjust = 7, color = NA) +
  labs(x = NULL, y = unname(latex2exp::TeX('$\\mu$g/m$^3$'))) +
  scale_fill_flat_d(guide = FALSE)+
  theme_classic() +
  theme(axis.line.y = element_blank(),
        axis.title.x = element_text(hjust = 1, size = 10, margin = margin(t = -3, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size = 7.5))+
  coord_flip() +
  scale_x_discrete(expand = c(0.07, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  facet_grid(cols = vars(Component), scales = "free_x")
ggsave("Exposure_violin_density.png", p_violin, width = 8, height = 4, dpi = 500)










d2 = d %>%
  .[,`:=`(BC = round(BC*100/PM25, 1),
          DUST = round(DUST*100/PM25, 1),
          NH4 = round(NH4*100/PM25, 1),
          NO3 = round(NO3*100/PM25, 1),
          OM = round(OM*100/PM25, 1),
          SO4 = round(SO4*100/PM25, 1),
          SS = round(SS*100/PM25, 1))] %>%
  .[,.(PM2.5 = NA_real_, BC, DUST, NH4, NO3, OM, SO4, SS)] %>%
  melt(measure.vars = c('PM2.5', 'BC', 'DUST', 'NH4',
                        'NO3', 'OM', 'SO4', 'SS'),
       variable.name = "Component",
       value.name = "Percent")
p3 = d2 %>%
  .[sample(.N, 0.01*.N)] %>%
  ggplot(aes(Component, Percent)) +
  geom_boxplot() +
  labs(x = NULL) +
  theme_hc()

p_all = p1|(p3/p2)
p_all = p_all + plot_annotation(tag_levels = c('A', '1'))
ggsave('figures/exposure_fig1_0.01.png', p_all,
       width = 10, height = 6.18, dpi = 400)





ind = sample(nrow(d1), 100)
z = bind_cols(d1[ind,], d2[ind,.(Percent)])

p2 = d1 %>%
  .[ind,] %>%
  ggplot(aes(Component, `ug/m2`)) +
  geom_boxplot() +
  labs(x = NULL) +
  theme_hc()
p3 = d2 %>%
  .[ind,] %>%
  ggplot(aes(Component, Percent)) +
  geom_boxplot() +
  labs(x = NULL, y = "ug/m3") +
  theme_hc()

p_all = p1|(p3/p2)
p_all + plot_annotation(tag_levels = c('A', '1'))
ggsave('figures/exposure_fig1.png', width = 10, height = 6.18, dpi = 400)





