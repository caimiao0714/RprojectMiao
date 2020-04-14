pacman::p_load(data.table, magrittr)
all_folders = list.dirs(full.names = FALSE, recursive = FALSE) %>%
  .[grepl(pattern = "PM25|BC|DUST|NH4|NO3|OM|SO4|SS", x = .)]

# Quoted by Dr. van Donkelaar:
# the coordinates given are the lower left corner of the provided region,
# "xllcenter" corresponding to the minimum longitude coordinate,
# and "yllcenter" corresponding to the minimum latitude coordinate.
# "Cellsize" provides you with the resolution.
# "Ncols" provides the number of longitudes in the grid,
# "nrows" provides the number of latitudes in the grid."


# Data validation
i = 1
j = 1

ind = list.files(all_folders[j], pattern = "\\.zip") %>%
  grepl(pattern = paste(2009:2017, collapse = "|"), x = .)
file_names = list.files(all_folders[j], pattern = "\\.zip") %>%
  .[ind]
file_year = file_names %>%
  gsub(pattern = ".*(2009|2010|2011|2012|2013|2014|2015|2016|2017).*", replacement = "\\1", .) %>%
  as.integer()

ls_pm25 = list()
for (i in seq_along(file_names)) {
  print(paste0(i, " out of ", length(file_names), ", ",
               round(i*100/length(file_names), 2), "%"))
  d = fread(cmd = paste0("unzip -p ", all_folders[j], "/", file_names[i]),# delete cmd = and "unzip -p ", if you are reading unzipped file
            fill = T)
  drows = d[V1 == "nrows",as.integer(V2)]
  dcols = d[V1 == "ncols",as.integer(V2)]
  x_start = d[V1 == "xllcenter",as.numeric(V2)]
  y_start = d[V1 == "yllcenter",as.numeric(V2)]
  cell_size = d[V1 == "cellsize",as.numeric(V2)]
  missing_value = d[V1 == "NODATA_value",as.numeric(V2)]

  d1 = d[(.N - drows + 1):.N,]
  var_names = as.character(seq(from = x_start,
                               to = x_start + (dcols - 1)*cell_size,
                               by = cell_size))
  setnames(d1, var_names)
  # rev (reverse) y since the coordinate starts from the left bottom corner
  d1[,y := rev(seq(from = y_start, to = y_start + (drows - 1)*0.01, by = 0.01))]
  d1_long = melt(d1, id.vars = "y", measure.vars = var_names, variable.name = "x")
  d1_long = d1_long %>%
    .[,`:=`(value = as.numeric(value),
            x = as.numeric(as.character(x)),
            year = file_year[i])] %>%
    .[,.(x, y, year, value)] %>%
    .[order(x, y)] %>%
    .[value != missing_value]

  ls_pm25[[i]] = d1_long
}

















for (j in 8) {

  ind = list.files(all_folders[j], pattern = "\\.zip") %>%
    grepl(pattern = paste(2009:2017, collapse = "|"), x = .)
  file_names = list.files(all_folders[j], pattern = "\\.zip") %>%
    .[ind]
  file_year = file_names %>%
    gsub(pattern = ".*(2009|2010|2011|2012|2013|2014|2015|2016|2017).*", replacement = "\\1", .) %>%
    as.integer()

  ls_pm25 = list()
  for (i in seq_along(file_names)) {
    print(paste0(i, " out of ", length(file_names), ", ",
                 round(i*100/length(file_names), 2), "%"))
    d = fread(cmd = paste0("unzip -p ", all_folders[j], "/", file_names[i]),# delete cmd = and "unzip -p ", if you are reading unzipped file
              fill = T)
    drows = d[V1 == "nrows",as.integer(V2)]
    dcols = d[V1 == "ncols",as.integer(V2)]
    x_start = d[V1 == "xllcenter",as.numeric(V2)]
    y_start = d[V1 == "yllcenter",as.numeric(V2)]

    d1 = d[(.N - drows + 1):.N,]
    var_names = as.character(seq(from = x_start,
                                 to = x_start + (dcols - 1)*0.01,
                                 by = 0.01))
    setnames(d1, var_names)
    d1[,y := rev(seq(from = y_start, to = y_start + (drows - 1)*0.01, by = 0.01))]
    d1_long = melt(d1, id.vars = "y", measure.vars = var_names, variable.name = "x")
    d1_long = d1_long %>%
      .[,`:=`(value = as.numeric(value),
              x = as.numeric(as.character(x)),
              year = file_year[i])] %>%
      .[,.(x, y, year, value)] %>%
      .[order(x, y)] %>%
      .[value != -999]

    ls_pm25[[i]] = d1_long
  }

  saveRDS(ls_pm25, paste0("comb_dat/ls_", all_folders[j], ".rds"))
}
