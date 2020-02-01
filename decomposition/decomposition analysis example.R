smoke = c("NS", "NS", "FS", "FS", "CS", "CS")
gender = c("F", "M", "F", "M", "F", "M")
p2008 = c(0.2, 0.2, 0.1, 0.2, 0.15, 0.15)
p2018 = c(0.1, 0.1, 0.2, 0.2, 0.10, 0.30)
Rate = c(1, 2, 3, 5, 6, 10)

delta = sum(p2018*Rate) - sum(p2008*Rate)


sum((p2018 - p2008)*Rate)

sum(p2008[gender == "F"]*Rate[gender == "F"] + p2018[gender == "F"]*Rate[gender == "F"])/sum(p2008[gender == "F"] + p2018[gender == "F"])

sum(p2008[gender == "M"]*Rate[gender == "M"] + p2018[gender == "M"]*Rate[gender == "M"])/sum(p2008[gender == "M"] + p2018[gender == "M"])



sm = "CS"
sum(p2008[smoke == sm]*Rate[smoke == sm] + p2018[smoke == sm]*Rate[smoke == sm])/sum(p2008[smoke == sm] + p2018[smoke == sm])



# need to install Cygwin first
# https://cygwin.com/install.html
# devtools::install_github('sadatnfs/dgdecomp/dgdecomp')
library(dgdecomp)

# create pdf user manual
path <- find.package("dgdecomp")
system(paste(shQuote(file.path(R.home("bin"), "R")),
             "CMD", "Rd2pdf", shQuote(path)))


# start example
library(dgdecomp)
set.seed(123)
number_of_factors = 26
#threads = 5
sim_dt <- simulate_decomp_data_fullmat(T_term = 2,
                                       num_factors = number_of_factors,
                                       id_grps = 1)

decomp_out_DT <- Decomp_on_DT(
  input_data = sim_dt,
  factor_names = paste0("X_", c(1:number_of_factors)),
  bycol = "Id",
  time_col = "t"
  #parallel = threads
)

decomp_out_DT

sum(decomp_out_DT)
sum(sim_dt[2,]) - sum(sim_dt[1,])
