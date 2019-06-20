r = 0.05
N = 1000
options(scipen = 10)

distance = rnorm(N, 3000, 800)
lam_SCE = rgamma(N, 1, 1)/100
lam_crash = lam_SCE*r

N_crash = rpois(N, lam_crash*distance)
N_SCE = rpois(N, lam_SCE*distance)

model0_N = glm(N_crash ~ N_SCE, offset = log(distance), family = "poisson")
model0_N$coefficients


model1_rate = glm(N_crash ~ lam_SCE, offset = log(distance), family = "poisson")
model1_rate$coefficients

model2_lograte = glm(N_crash ~ log(lam_SCE), offset = log(distance), family = "poisson")
model2_lograte$coefficients
