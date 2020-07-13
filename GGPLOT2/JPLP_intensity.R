pacman::p_load(ggplot2, dplyr, directlabels, latex2exp)
windowsFonts(Times = windowsFont("Times New Roman"))

############  Function: to simulating JPLP ############
inverse = function (f, lower = 0.0001, upper = 1000) {
  function (y) uniroot((function (x) f(x) - y), lower = lower, upper = upper)[1]
}

Lambda_PLP = function(t, beta = 1.5, theta = 4) return((t/theta)^beta)

Lambda_JPLP = function(t,
                       tau = 12,
                       kappa = 0.8,
                       t_trip = c(3.5, 6.2, 9),
                       beta = 1.5,
                       theta = 4)
{
  t_trip1 = c(0, t_trip)
  n_trip = length(t_trip1)
  comp = Lambda_PLP(t_trip, beta, theta)
  kappa_vec0 = rep(kappa, n_trip - 1)^(0:(n_trip - 2))
  kappa_vec1 = rep(kappa, n_trip - 1)^(1:(n_trip - 1))
  cum_comp0 = comp*kappa_vec0
  cum_comp1 = comp*kappa_vec1
  index_trip = max(cumsum(t > t_trip1)) - 1

  if(index_trip == 0){
    return((t/theta)^beta)
  }else{
    return(sum(cum_comp0[1:index_trip]) - sum(cum_comp1[1:index_trip]) +
             kappa^index_trip*(t/theta)^beta)
  }
}

sim_jplp = function(tau0 = 12,
                    kappa0 = 0.8,
                    t_trip0 = c(3.5, 6.2, 9),
                    beta0 = 1.5,
                    theta0 = 0.5)
{ s = 0; t = 0
  Lambda1 = function(t, tau1 = tau0, kappa1 = kappa0, t_trip1 = t_trip0,
                   beta1 = beta0, theta1 = theta0)
  {
    return(Lambda_JPLP(t, tau = tau1, kappa = kappa1, t_trip = t_trip1,
                       beta = beta1, theta = theta1))
  }
  inv_Lambda = inverse(Lambda1, 0.0001, 100)

  while (max(t) <= tau0) {
    u <- runif(1)
    s <- s - log(u)
    t_new <- inv_Lambda(s)$root
    t <- c(t, t_new)
  }
  t = t[c(-1, -length(t))]

  return(t)
}

############   Simulate data   ############
set.seed(666)

tauX = 11
kappaX = 0.8
t_tripX = c(3.5, 6.2, 9)
betaX = 1.5
thetaX = 1

t_events = sim_jplp(tau0 = tauX,
                    kappa0 = kappaX,
                    t_trip0 = t_tripX,
                    beta0 = betaX,
                    theta0 = thetaX)

lambda_plp = function(t, beta, theta) return(beta*theta^(-beta)*t^(beta - 1))
lambda_jplp = function(t, beta, theta, kappa = 0.8, t_trip){
  index_trip = max(cumsum(t > t_trip))
  return((kappa^index_trip)*beta*theta^(-beta)*t^(beta - 1))
}


x = seq(0.00, tauX, 0.001)
y_plp = lambda_plp(x, beta = betaX, theta = thetaX)
y_jplp = rep(NA_real_, length(lambda_plp))

for (i in 1:length(x)) {
  y_jplp[i] = lambda_jplp(x[i],
                          beta = betaX, theta = thetaX,
                          kappa = 0.8, t_trip = t_tripX)
}


dlambda = tibble::tibble(x, y_plp, y_jplp) %>%
  tidyr::pivot_longer(cols = c('y_plp', 'y_jplp'),
                      names_to = "Type",
                      values_to = 'y') %>%
  mutate(Type = case_when(Type == 'y_plp' ~ 'PLP',
                          Type == 'y_jplp' ~ 'JPLP')) %>%
  mutate(Type = factor(Type, levels = c('PLP', 'JPLP')))

d_event = data.frame(t_events = t_events, y = 0)
d_shift = data.frame(start_x = 0, end_x = tauX, start_y = 0, end_y = 0)



############    Plotting    ############
ggplot() +
  # Vertical lines indicating stops
  geom_vline(xintercept = t_tripX, linetype = "dashed", color = '#4daf4a') +
  geom_text(data = data.frame(x = t_tripX, y = 1, label = c("rest 1", "rest 2", "rest 3")),
            aes(x = x, y = y, label = label),
            color = '#4daf4a', nudge_x = 0.55, size = 5.5, family = 'Times') +
  geom_line(data = filter(dlambda, Type == 'PLP'),
            aes(x = x, y = y), color = "#0082c8") +
  # four segments of JPLP intensity function lambda
  geom_line(data = filter(dlambda, Type == 'JPLP' & x <= t_tripX[1]),
            aes(x = x, y = y), color = "#4b0082") +
  geom_line(data = filter(dlambda, Type == 'JPLP' & x > t_tripX[1] & x <= t_tripX[2]),
            aes(x = x, y = y), color = "#4b0082") +
  geom_line(data = filter(dlambda, Type == 'JPLP' & x > t_tripX[2] & x <= t_tripX[3]),
            aes(x = x, y = y), color = "#4b0082") +
  geom_line(data = filter(dlambda, Type == 'JPLP' & x > t_tripX[3]),
            aes(x = x, y = y), color = "#4b0082") +
  # direct labels of PLP and JPLP
  geom_dl(data = dlambda, aes(x = x, y = y, label = Type, color = Type),
          method = list(dl.trans(x = x - 1.3, y = y - 0.6),
                        "last.points", cex = 1.4, fontfamily = 'Times')) +
  scale_color_manual(values = c(PLP = "#0082c8", JPLP = "#4b0082")) +
  # Points that suggest non-overlapping intensity function at jump points
  geom_point(data = filter(dlambda, Type == 'JPLP', x %in% (t_tripX + 0.001)),
             aes(x = x, y = y), color = '#4b0082', size = 5, shape = 1) +
  geom_point(data = data.frame(x = 0, y = 0), aes(x = x, y = y), 
             color = '#4b0082', size = 5, shape = 1) +
  labs(x = unname(TeX('Time to SCEs (hours)')),
       y = unname(TeX('Intensity $\\lambda(t)$'))) +
  theme_minimal() +
  guides(color = FALSE) +
  geom_point(data = d_event, aes(x = t_events, y = y),
             alpha = 0.8, shape = 4, color = 'red', size = 3) +
  geom_segment(data = d_shift,
               aes(x = start_x, xend = end_x,
                   y = start_y, yend = end_y),
               lineend = 'butt',
               arrow = arrow(length = unit(0.2, "cm"))) +
  scale_x_continuous(expand = c(0., 0.15), breaks = c(0, 3, 6, 9, 11)) +
  theme(axis.text = element_text(size = 16, family = 'Times'),
        axis.title = element_text(size = 16, family = 'Times'),
        axis.ticks.x = element_line(size = 0.9),
        axis.ticks.length = unit(0.2, 'cm'),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = 'Times'))
ggsave('Figures/JPLP_intensity.pdf', width = 10*.75, height = 6.18*.75)
