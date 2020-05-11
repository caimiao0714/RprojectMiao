pacman::p_load(dplyr, data.table, lme4, mgcv, broom)

d = fread('misce/IQ/Lead_Final(1).csv') %>%
  .[,`:=`(ses = factor(ses),
          school = factor(school))]

f0 = glm(IQ ~ Pb + age + sex + BMI + factor(ses) + interest + ownhome,
         data = d)
f1 = lmer(IQ ~ Pb + age + sex + BMI + factor(ses) + interest + ownhome +
             (1|school),
         data = d)

f2 = mgcv::gam(IQ ~ s(Pb, k = 15, bs = 'tp') + age + sex + BMI + ses + interest + ownhome,
               data = d, method="REML", family="gaussian")

f3 = mgcv::gam(IQ ~ s(Pb, k = 15, bs = 'tp') + s(school, bs = 're') + age + sex + BMI + ses + interest + ownhome,
               data = d, method="REML", family="gaussian")

glance(f0)
glance(f1) # this seems to be the best model
glance(f2)
glance(f3)

plot(f2)
plot(f3)
