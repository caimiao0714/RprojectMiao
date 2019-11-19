x = 10

g0 = function(){
  x <- 20
  x
}
g0()
x

x = 10
g1 = function(){
  x <<- 20
  x
}

g1()
x
