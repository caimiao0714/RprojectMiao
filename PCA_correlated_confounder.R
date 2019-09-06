pacman::p_load(MASS)

mu = c(0, 0)
sigma = matrix(c(1, -0.6, -0.6, 4), nrow = 2, byrow = 2)

d = MASS::mvrnorm(100, mu, sigma)
cor(d[,1], d[,2])

p = prcomp(d, center = TRUE, scale. = TRUE)
summary(p)
p1 = p$x[,1]; p2 = p$x[,2]

cor(d[,1], p1); cor(d[,2], p1) # Same value different directions
cor(d[,1], p2); cor(d[,2], p2) # Same value same directions


layout(matrix(c(1, 1, 2, 3, 4, 5), 3, 2, byrow = TRUE))
plot(d[,1], d[,2], main = "Correlation between d1 and d2")
plot(d[,1], p1, main = "Correlation between d1 and p1")
plot(d[,2], p1, main = "Correlation between d2 and p1")
plot(d[,1], p2, main = "Correlation between d1 and p2")
plot(d[,2], p2, main = "Correlation between d2 and p2")
