library(data.table)
mtcars = data.table(mtcars)

zz = function(d, var, group) {
  return(d[,sum(get(var)), eval(group)])
}
zz(mtcars, mpg, gear)


# https://stackoverflow.com/questions/58648886/a-simple-reproducible-example-to-pass-arguments-to-data-table-in-a-self-defined
zz1 <- function(data, var, group){
  var <- substitute(var)
  group <- substitute(group)
  setnames(data[, sum(eval(var)), by = group],
           c(deparse(group), deparse(var)))[]
  # or use
  #  setnames(data[, sum(eval(var)), by = c(deparse(group))], 2, deparse(var))[]
}
zz1(mtcars, mpg, gear)


# https://stackoverflow.com/questions/58649510/why-does-substitute-work-in-multiple-lines-but-not-in-a-single-line
pacman::p_load(rlang)
gregor_rlang = function(data, var, group) {
  data[, sum(eval(enexpr(var))), by = .(group = eval(enexpr(group)))]
}
gregor_rlang(mtcars, mpg, cyl)
