set.seed(123)
x1 = sample(0:1, 100, replace = T, prob = c(0.7, 0.3))
x2 = sample(1:4, 100, replace = T)
p = 1/(1 + exp(-2 + x1 + x2))
y = rbinom(length(p), size = 1, prob = p)

fit = glm(y ~ x1 + x2, family = "binomial")
pred_y0 = predict(object = fit,
                 newdata = data.frame(x1 = x1, x2 = x2),
                 type = "response")
sum(pred_y0)
sum(y)
pred_y1 = predict(object = fit,
                  newdata = data.frame(x1 = rev(x1), x2 = x2),
                  type = "response")
sum(pred_y1)

