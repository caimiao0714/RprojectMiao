pacman::p_load(data.table, dplyr, mgcv, MASS, broom)

d0 = fread('GAM/Wuhan.csv') %>% .[case > 0,.(case, death, PM2.5, t, h, w)]
d1 = fread('GAM/Beijing.csv') %>% .[,.(case, death, PM2.5, t, h, w)]


f0 = gam(death ~ PM2.5 + t + h + w + offset(log(case)),
         family = nb(link='log'), data = d0, method = 'REML')
f1 = gam(death ~ s(PM2.5, k = 10) + t + h + w + offset(log(case)),
         family = nb(link='log'), data = d0, method = 'REML')

summary(f0)
summary(f1)
tidy(f0, parametric = TRUE)
tidy(f1, parametric = TRUE)
broom::glance(f0)
broom::glance(f1)

f1 = gam(death ~ s(PM2.5) + t + h + w + offset(log(case)),
         family = nb(link='log'), data = d1, method = 'REML')
plot(f0)
plot(f1)

summary(f1)




