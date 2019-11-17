z = function(){
  x <<- 3
}
z()

for (i in 1:4) {
  assign(paste0("t", i), i)
}

