f <- function() { 
  sum <- 0.5; 
  for(i in 1:1e8){
    sum <- sum+i 
  }
}
system.time( f() )


library(compiler)
g <- cmpfun(f)
system.time( g() )

# not working??