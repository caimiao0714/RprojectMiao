library(glmnet)
library(data.table)
library(dplyr)

d = fread("multilogit_LASSO/pd_speech_features/pd_speech_features.csv", skip = 1) %>%
  .[, `:=`(y_cat = case_when(PPE < 0.762 ~ 0,
                             PPE >= 0.762 & PPE < 0.809 ~ 1,
                             PPE >= 0.809 & PPE < 0.834 ~ 2,
                             PPE >= 0.834  ~ 3),
           PPE = NULL)]

