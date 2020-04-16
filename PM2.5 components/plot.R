pacman::p_load(raster, magrittr, ncdf4)

get_raster = function(folder = "PM2.5"){
  ind09_17 = list.files(folder, pattern = "\\.nc") %>%
    grepl(pattern = paste(2009:2017, collapse = "|"), x = .)
  file_names = list.files(folder, pattern = "\\.nc") %>%
    .[ind09_17]
  file_year = file_names %>%
    gsub(pattern = ".*(2009|2010|2011|2012|2013|2014|2015|2016|2017).*", replacement = "\\1", .) %>%
    as.integer()

  file_names = file_names[order(file_year)]
  file_year = file_year[order(file_year)]

  ls_raster = list()
  for (i in seq_along(file_names)) {
    ls_raster[[i]] = raster::raster(paste0(folder, "/", file_names[i]))
  }

  return(ls_raster)
}

ls_PM2.5 = get_raster("PM2.5")
ls_BC = get_raster("BC")
ls_DUST = get_raster("DUST")
ls_NH4 = get_raster("NH4")
ls_NO3 = get_raster("NO3")
ls_OM = get_raster("OM")
ls_SO4 = get_raster("SO4")
ls_SS = get_raster("SS")


file_year = 2009:2017


par(mfrow = c(9, 8),
    mar = c(1, 2.2, 1, 2.2))
#mai = c(1, 2, 1, 2)

for (i in seq_along(file_year)) {
  plot(ls_PM2.5[[i]], main = paste0("PM2.5, ", file_year[i]), xlim = c(-138, -45), xlab = NULL, ylab = NULL)
  plot(ls_BC[[i]], main = paste0("Black Carbon, ", file_year[i]), xlim = c(-138, -45), xlab = NULL, ylab = NULL)
  plot(ls_DUST[[i]], main = paste0("Dust, ", file_year[i]), xlim = c(-138, -45), xlab = NULL, ylab = NULL)
  plot(ls_NH4[[i]], main = paste0("NH4, ", file_year[i]), xlim = c(-138, -45), xlab = NULL, ylab = NULL)
  plot(ls_NO3[[i]], main = paste0("NO3, ", file_year[i]), xlim = c(-138, -45), xlab = NULL, ylab = NULL)
  plot(ls_OM[[i]], main = paste0("OM, ", file_year[i]), xlim = c(-138, -45), xlab = NULL, ylab = NULL)
  plot(ls_SO4[[i]], main = paste0("SO4, ", file_year[i]), xlim = c(-138, -45), xlab = NULL, ylab = NULL)
}



z = raster::raster("PM2.5/GWRwSPEC_PM25_NA_200901_200912-RH35.nc")
plot(z)
