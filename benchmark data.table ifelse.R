set.seed(7)

pacman::p_load(microbenchmark, data.table)

f_gdata = function(){
  z = data.table(x = sample(c(NA_integer_, 1), 5e7, TRUE))
  z[,x := gdata::NAToUnknown(x, 0)]
  return(z)
}

f_fifelse = function(){
  z = data.table(x = sample(c(NA_integer_, 1), 5e7, TRUE))
  z[,x := fifelse(is.na(x), 0, x)]
  return(z)
}

f_twostep = function(){
  z = data.table(x = sample(c(NA_integer_, 1), 5e7, TRUE))
  z[is.na(x), x := 0]
  return(z)
}


microbenchmark::microbenchmark(f_gdata, f_fifelse, f_twostep)

# Unit: nanoseconds
# expr min lq  mean median uq  max neval cld
# f_gdata  37 42 57.06     42 43 1374   100   a
# f_fifelse  34 37 45.01     39 40  675   100   a
# f_twostep  31 35 40.47     36 37  514   100   a