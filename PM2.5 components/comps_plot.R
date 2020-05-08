pacman::p_load(data.table, ggplot2, dplyr, ggthemes, latex2exp, extrafont, cowplot, splines2, directlabels)

font_import()
loadfonts(device = "win")

d = fread('data/foroptplot.csv')


human_numbers <- function(x = NULL, smbl ="", signif = 1){
  humanity <- function(y){

    if (!is.na(y)){
      tn <- round(abs(y) / 1e12, signif)
      b <- round(abs(y) / 1e9, signif)
      m <- round(abs(y) / 1e6, signif)
      k <- round(abs(y) / 1e3, signif)

      if ( y >= 0 ){
        y_is_positive <- ""
      } else {
        y_is_positive <- "-"
      }

      if ( k < 1 ) {
        paste0( y_is_positive, smbl, round(abs(y), signif ))
      } else if ( m < 1){
        paste0 (y_is_positive, smbl,  k , "k")
      } else if (b < 1){
        paste0 (y_is_positive, smbl, m ,"m")
      }else if(tn < 1){
        paste0 (y_is_positive, smbl, b ,"bn")
      } else {
        paste0 (y_is_positive, smbl,  comma(tn), "tn")
      }
    } else if (is.na(y) | is.null(y)){
      "-"
    }
  }

  sapply(x,humanity)
}


d %>%
  ggplot(aes(x = ap, y = rr_mean)) +
  geom_line(color = '#4271AE', size = 1.5, alpha = 0.9) +
  geom_ribbon(aes(ymin = rr_lcl, ymax = rr_ucl), alpha = 0.3) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 15.5),
                     breaks = seq(0, 15, 2.5), labels = human_numbers) +
  scale_y_continuous(expand = c(0, 0), limits = c(1, NA)) +
  labs(x = unname(TeX('PM$_{2.5}$ concentration ($\\mu$g/m$^3$)')),
       y = 'Hazard Ratio (95% CI)') +
  cowplot::theme_minimal_hgrid() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        text = element_text(family = "Arial"),
        axis.text=element_text(size = 16),
        axis.title=element_text(size = 16))

ggsave('nonlinear_ggplot2.png', width = 10*0.7, heigh = 6.18*0.65, dpi = 400)






### Modulation factor plot
pacman::p_load(directlabels)
comp_dt = data.frame(
  components = c('BC', 'DUST', 'NH4', 'NO3', 'OM', 'SO4', 'SS'),
  beta = c(0.078, -0.002, -0.02, 0.016, 0.03, 0.046, 0.021),
  min_prop = c(0.06, 0.03, 0.015, 0.04, 0.3, 0.08, 0.001),
  max_prop = c(0.15, 0.22, 0.18, 0.22, 0.6, 0.3, 0.15)
)

plt = function(plt_dt){
  p = plt_dt %>%
    ggplot(aes(comp_p, HR)) +
    geom_line() + theme_bw()
  return(p)
}


gtdt = function(i, exp_factor, scale_Factor){
  comp_p = seq(comp_dt$min_prop[i], comp_dt$max_prop[i], 0.001)
  b_dirt = ifelse(comp_dt$beta[i] > 0, 1, -1)

  dt = data.table(components = comp_dt$components[i],
                  comp_p = comp_p,
                  HR = exp(b_dirt*comp_p^exp_factor*scale_Factor),
                  b_sd = rnorm(1, 0.008, 0.002))
  return(dt)
}

set.seed(66)
comp_p = seq(comp_dt$min_prop[1], comp_dt$max_prop[1], 0.001)
BC_dt = data.table(components = comp_dt$components[1],
                   comp_p = comp_p,
                   HR = 1.2-10*(comp_p - 0.15)^2,
                    b_sd = rnorm(1, 0.008, 0.002))
DUST_dt = gtdt(2, 0.6, 0.05)
NH4_dt = gtdt(3, 0.5, 0.12)
NO3_dt = gtdt(4, 0.8, 0.05)
OM_dt = gtdt(5, 0.5, 0.15)
comp_p = seq(comp_dt$min_prop[6], comp_dt$max_prop[6], 0.001)
SO4_dt = data.table(components = comp_dt$components[6],
                    comp_p = comp_p,
                    HR = 1.13-1.8*(comp_p - 0.28)^2,
                    b_sd = rnorm(1, 0.008, 0.002))
SS_dt = gtdt(7, 0.9, 0.11)


bind_rows(BC_dt, DUST_dt, NH4_dt,
          NO3_dt, OM_dt, SO4_dt, SS_dt) %>%
  mutate(HR_low = HR*exp(b_sd),
         HR_high = HR*exp(-b_sd)) %>%
  ggplot(aes(comp_p, HR, group = components, color = components)) +
  scale_x_continuous(expand = c(0.001, 0), limits = c(0, 0.65), labels = human_numbers) +
  #scale_y_continuous(labels = human_numbers) +
  geom_line(size = 1) +
  geom_ribbon(aes(ymin=HR_low,ymax=HR_high, fill = components),color = NA, alpha=0.3)+
  cowplot::theme_minimal_hgrid() +
  guides(color = FALSE, fill = FALSE) +
  labs(x = "Component percentage", y = 'Modulation factor')+
  geom_dl(aes(label = components),
          method = list(dl.trans(x = x + 0.2), "last.points", cex = 1.2)) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        text = element_text(family = "Arial"),
        axis.text=element_text(size = 15, color = 'gray40'),
        axis.title=element_text(size = 18))

ggsave('modulation_ggplot2.png', width = 10*0.8, heigh = 6.18*0.8, dpi = 400)






#### Marginal plot
BC_PM5  = seq(1.5, 19.0, 0.001)
BC_PM10 = seq(2.2, 18.5, 0.001)
BC_PM15 = seq(3.0, 17.5, 0.001)
PM5 = data.table(PM = '5',
                 BC_prop = BC_PM5,
                 HR = 1.12 - 0.0004*(BC_PM5 - 18)^2)
PM10 = data.table(PM = '10',
                 BC_prop = BC_PM10,
                 HR =  exp(log(BC_PM10, base = 3.2)/10))
PM15 = data.table(PM = '15',
                  BC_prop = BC_PM15,
                  HR = 2. - 0.0004*(BC_PM15 - 45)^2 - 0.012*BC_PM15)



bind_rows(PM5, PM10, PM15) %>%
  #mutate(PM = factor(PM, levels = c('5', '10', '15'))) %>%
  ggplot(aes(BC_prop, HR, group = PM, color = PM)) +
  geom_line(size = 1) +
  geom_dl(aes(label = PM),
          method = list(dl.trans(x = x + 0.2), "last.points", cex = 1.2)) +
  scale_color_discrete(values = c(
    '5' = unname(TeX("PM$_{2.5}$:$\\;$ 5 $\\mu g/m^3$")),
    '10' = unname(TeX("PM$_{2.5}$: 10 $\\mu g/m^3$")),
    '15' = unname(TeX("PM$_{2.5}$: 15 $\\mu g/m^3$"))
  )) +

  cowplot::theme_minimal_hgrid() +
  guides(color = FALSE, fill = FALSE) +
  labs(x = "Black Carbon Porportion (%)",
       y = unname(TeX('Hazard Ratio for Total PM$_{2.5}')))+

  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        text = element_text(family = "Arial"),
        axis.text=element_text(size = 15, color = 'gray40'),
        axis.title=element_text(size = 18))

unname(TeX(
  c("PM$_{2.5}$:$\\;$ 5 $\\mu g/m^3$",
    "PM$_{2.5}$: 10 $\\mu g/m^3$",
    "PM$_{2.5}$: 15 $\\mu g/m^3$")))