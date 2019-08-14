x0 <- 1:10
n0 <- 3

chunk2 <- function(x,n) split(x, cut(seq_along(x), n, labels = FALSE))

z = chunk2(x0, n0)

split(x0, ceiling(seq_along(x0)/3))

# Does not make sense to me
# Ended up with using floor(cumsum(n_ping)/(2*10^7))
# Just set the dividend slightly smaller and it should work.