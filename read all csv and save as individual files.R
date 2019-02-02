library(data.table)
data_path = "healthcare2/"
csv_files = list.files(path = data_path, pattern = "*.csv")
readallcsv = function(i){
  assign(
    gsub(".csv", "", csv_files[i]),
    fread(paste0(data_path, csv_files[i])),
    envir = parent.frame()
  )
}
for (i in seq_along(csv_files))  readallcsv(i)