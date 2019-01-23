x = data.frame(x_1 = c(1, 2, 3), x_2 = c(1.1, 2.1, 3.1), x_3 = c(4, 5, 20), x_4 = letters[1:3], x_5 = c(5.2, 65.2, 26))

x

tellint = function(col){
  ifelse(is.numeric(col),
         as.logical(sum(col > 10)) | !isTRUE(all.equal(col, as.integer(col) )),
         FALSE)
}


x[,unlist(lapply(x, tellint)) ]



# an alternative solution using dplyr
dat %in% select_if(is.numeric)
