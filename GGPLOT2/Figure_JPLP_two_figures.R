pacman::p_load(ggplot2, dplyr, extrafont, patchwork)
windowsFonts(Times = windowsFont("Times New Roman"))

plp = function(t, beta = 2, theta = 10) return(beta*theta^(-beta)*t^(beta-1))
sim_plp_tau = function(tau = 30,
                       beta = 2,
                       theta = 10){
  # initialization
  s = 0; t = 0
  while (max(t) <= tau) {
    u <- runif(1)
    s <- s - log(u)
    t_new <- theta*s^(1/beta)
    t <- c(t, t_new)
  }
  t = t[c(-1, -length(t))] 
  
  return(t)
}


plp = function(t, beta = 2, theta = 10) return(beta*theta^(-beta)*t^(beta-1))

set.seed(223)
tau0 = 13; beta0 = 1.2; theta0 = 2
rest_time = c(4, 8)

# SCE time
t_SCE = c(1.5081062, 2.9090437, 3.821632, 
          4.75131, 6.3752535, 7.2168730, 
          10.5380954, 12.1135213)
shift_id= rep(0, length(t_SCE))
SCE = data.frame(shift_id, t_SCE)

# Intensity and limit
INTENS = data.frame(t = seq(0, tau0, 0.001),
                    intensity = plp(seq(0, tau0, 0.001), beta0, theta0)) %>% 
  mutate(type = ifelse(((t >= rest_time[1] & t <= rest_time[2])|(t >= rest_time[3] & t <= rest_time[4])), 0.2, 1))

# LIM data
LIM = data.frame(start_time = 0, end_time = tau0, shift_id = shift_id)

# maximum intensity
max_int = round(max(INTENS$intensity), 2) + 0.01

# plot
p0 = ggplot() + 
  geom_line(data = INTENS, aes(x = t, y = intensity), size = 0.8) + 
  geom_point(data = SCE, aes(x = t_SCE, y = shift_id), 
             alpha = 1, shape = 4, color = 'red', size = 1.5, stroke = 1.2) + 
  geom_segment(data = LIM, 
               aes(x = start_time, xend = end_time, y = shift_id, yend = shift_id),
               arrow = arrow(length = unit(0.2, "cm")), lineend = 'butt', size = 0.8) + 
  scale_x_continuous(expand = c(0.001, 0))+
  scale_y_continuous(labels = c(0, max_int), breaks = c(0, max_int), 
                     expand = c(0.05, 0)) +
  geom_vline(xintercept = rest_time[1], color="green", 
             alpha = 0.7, size = 1.2, linetype = "dashed") + 
  geom_vline(xintercept = rest_time[2], color="green", 
             alpha = 0.7, size = 1.2, linetype = "dashed") +
  labs(x = unname(latex2exp::TeX('Time to SCEs (hours), $t_1 \\rightarrow t_n$')), 
       y = "intensity",
       title = "Power Law Process") + 
  geom_text(aes(x = c(4.7, 8.7), y = rep(max_int/3, 2), 
                label = c("rest 1","rest 2")), 
            color = "darkgreen", size = 5, family="Times") +
  #scale_y_continuous(breaks = c(0, 0.88), limits = c(-0.1, 0.88)) +
  theme_bw()+
  theme(panel.grid = element_blank(),
        text = element_text(size=10, family="Times"),
        axis.title.y = element_text(margin = margin(t = 0, r = -12, b = 0, l = 0)))
#p0
#ggsave("Figures/Figure_JPLP_PLP.pdf", p0, width = 10, height = 6.18)




set.seed(223)
tau0 = 13; beta0 = 1.2; theta0 = 2; kappa = 0.8
rest_time = c(4, 8)

# SCE time
t_SCE = c(1.5081062, 2.9090437, 3.821632, 
          4.75131, 6.3752535, 7.2168730, 
          10.5380954, 12.1135213)
shift_id= rep(0, length(t_SCE))
SCE = data.frame(shift_id, t_SCE)

# Intensity and limit
INTENS = data.frame(t = seq(0, tau0, 0.001),
                    intensity = plp(seq(0, tau0, 0.001), beta0, theta0)) %>% 
  mutate(intensity1 = case_when(
    t >= rest_time[1] & t <= rest_time[2] ~ intensity*kappa^1,
    t >= rest_time[2]  ~ intensity*kappa^2,
    TRUE ~ intensity*kappa^0))

# plot
p1 = ggplot() + 
  geom_line(data = INTENS[INTENS$t < rest_time[1],], 
            aes(x = t, y = intensity1), size = 0.8) + 
  geom_line(data = INTENS[INTENS$t > rest_time[1]&INTENS$t <= rest_time[2],], 
            aes(x = t, y = intensity1), size = 0.8) + 
  geom_line(data = INTENS[INTENS$t > rest_time[2],], 
            aes(x = t, y = intensity1), size = 0.8) + 
  geom_line(data = INTENS, 
            aes(x = t, y = intensity), alpha = 0.3, size = 0.8)+
  geom_point(data = SCE, aes(x = t_SCE, y = shift_id), 
             alpha = 1, shape = 4, color = 'red', size = 1.5, stroke = 1.2) + 
  geom_segment(data = LIM, 
               aes(x = start_time, xend = end_time, y = shift_id, yend = shift_id),
               arrow = arrow(length = unit(0.2, "cm")), lineend = 'butt', size = 0.8) + 
  scale_x_continuous(expand = c(0.001, 0))+
  scale_y_continuous(labels = c(0, max_int), breaks = c(0, max_int), 
                     expand = c(0.05, 0)) +
  geom_vline(xintercept = rest_time[1], color="green", 
             alpha = 0.7, size = 1.2, linetype = "dashed") + 
  geom_vline(xintercept = rest_time[2], color="green", 
             alpha = 0.7, size = 1.2, linetype = "dashed")+
  labs(x = unname(latex2exp::TeX('Time to SCEs (hours), $t_1 \\rightarrow t_n$')), 
       y = "intensity",
       title = "Jump Power Law Process") + 
  geom_text(aes(x = c(4.7, 8.7), y = rep(max_int/3, 2), 
                label = c("rest 1","rest 2")), 
            color = "darkgreen", size = 5, family = "Times") +
  theme_bw()+
  theme(panel.grid = element_blank(),
        text = element_text(size=10, family = "Times"),
        axis.title.y = element_text(margin = margin(t = 0, r = -12, b = 0, l = 0)))
#p1
#ggsave("Figures/Figure_JPLP_Jump_PLP.pdf", p1, width = 10, height = 6.18)


p0|p1
ggsave("Figures/Figure_JPLP_two_figures.pdf", width = 8*0.4*2, height = 6.18*0.4)
