N = 100
S = matrix(c(2, 2,
             2, 3), 2, 2)

# correlated X
X = MASS::mvrnorm(N, c(1, 3), S)
BETA = c(0.5, 1)

y = 5 + X%*%BETA + rnorm(N, 0, 5)

plot(X[,1], X[,2])
plot(X[,1], y)
plot(X[,2], y)

model = lm(y ~ X[,1])
summary(model)

y_hat = predict(model)
e = y - y_hat

plot(y_hat, e)


n_sim = 1000
BETA = c(0.5, 0.5)
S = matrix(c(2, 0.2, 0.2, 3), 2, 2)
est_beta = matrix(rep(NA_real_, n_sim*2), ncol = 2)

for (i in seq_len(n_sim)) {
  X = MASS::mvrnorm(N, c(1, 3), S)
  y = 5 + X%*%BETA + rnorm(N, 0, 5)
  model = lm(y ~ X[,1])
  est_beta[i,] = model$coefficients
}

colMeans(est_beta)
# The estimated mean is consistent with the true values



#--------------#
# hetereogeity #
#--------------#
N = 100
b0 = 5
b1 = 0.5

x = sort(rnorm(N, 3, 2))
y = b0 + b1*x + rnorm(N, 0, log(seq_len(N)))

plot(x, y)

model1 = lm(y ~ x)
summary(model1)

y_hat = predict(model1)
e = y - y_hat

plot(y_hat, e)


n_sim = 1000
est_beta = matrix(rep(NA_real_, n_sim*2), ncol = 2)

for (i in seq_len(n_sim)) {
  x = sort(rnorm(N, 3, 2))
  y = b0 + b1*x + rnorm(N, 0, log(seq_len(N)))
  model1 = lm(y ~ x)
  est_beta[i,] = model1$coefficients
}

colMeans(est_beta)
# The estimated mean is consistent with the true values


