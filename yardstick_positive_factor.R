library(yardstick)
library(caret)

# create dummy dataset
predicted <- as.integer(c(1, 0, 1))
actual    <- as.integer(c(1, 0, 0))
df <- as.data.frame(cbind(predicted, actual))

# make sure columns are factors
df$predicted <- as.factor(df$predicted)
df$actual <- as.factor(df$actual)

# view summary with yardstick
yardstick::conf_mat(df, estimate=predicted, truth=actual)
summary(yardstick::conf_mat(df, estimate=predicted, truth=actual))

# view summary with caret
caret::confusionMatrix(data=df$predicted, reference=df$actual, positive = "1")

# Calculate sensitivity by hand
# Sensitivity = TP/P = TP / (TP + FN)
cat("Sensitivity =", 1 / (1 + 0))


# Consistent result when set first factor not to be the event
options(yardstick.event_first = FALSE)
yardstick::conf_mat(df, estimate=predicted, truth=actual)
summary(yardstick::conf_mat(df, estimate=predicted, truth=actual))
