smoke = c("NS", "NS", "FS", "FS", "CS", "CS")
gender = c("F", "M", "F", "M", "F", "M")
p2008 = c(0.2, 0.2, 0.1, 0.2, 0.15, 0.15)
p2018 = c(0.1, 0.1, 0.2, 0.2, 0.10, 0.30)
Rate = c(1, 2, 3, 5, 6, 10)

delta = sum(p2018*Rate) - sum(p2008*Rate)


