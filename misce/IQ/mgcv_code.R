pacman::p_load(dplyr, data.table, lme4, mgcv, broom, performance)

d = fread('misce/IQ/Lead_Final(1).csv') %>%
  .[,`:=`(ses = factor(ses),
          school = factor(school))]

f0 = glm(IQ ~ Pb + age + sex + BMI + ses + interest + ownhome,
         data = d)
f1 = lmer(IQ ~ Pb + age + sex + BMI + ses + interest + ownhome +
             (1|school),
         data = d)

f2 = mgcv::gam(IQ ~ s(Pb, k = 15, bs = 'tp') + age + sex + BMI + ses + interest + ownhome,
               data = d, method="REML", family="gaussian")

f3 = mgcv::gam(IQ ~ s(Pb, k = 15, bs = 'tp') + s(school, bs = 're') + age + sex + BMI + ses + interest + ownhome,
               data = d, method="REML", family="gaussian")

model_performance(f0)
model_performance(f1) # this seems to be the best model
model_performance(f2)
model_performance(f3)

icc(f1)

plot(f2)
plot(f3)
