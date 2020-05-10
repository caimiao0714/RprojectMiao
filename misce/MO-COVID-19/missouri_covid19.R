##Read in data
total1 <- read.csv("D:/×ÀÃæ/disease mapping/dailyupdate.csv")
#MO_map <- read.csv("D:/×ÀÃæ/disease mapping/MO_2018_County_Boundaries.csv")
head(MO_map)
shape <- st_read(
  "D:/×ÀÃæ/disease mapping/geo_export_714e58d7-558f-4df1-af96-16ca5d24323f.shp")
library(sf)
library( tmap )
library( rgdal )
library("data.table")
library(tidyverse)
library( tigris )
library(dplyr)
library(plyr)
library(reshape)
library(naniar)
###read in COVID DATA and prepare covid data for merge,make sure the variables name are the same.
###shape file doesn't have kansas city, so I have to delete cansas city in covid data.
MO_covid<- subset(total1,state=='Missouri'& ï»¿date=='2020/4/15')
MO_covid <- rename(MO_covid,c(county="countyname",fips="countyfips"))
MO_covid_noKan <- subset(MO_covid, countyname!="Kansas City"&countyname!="Unknown")
###SHAPE FILE
#county name are not consistant between two data.
shape$countyname <- revalue(shape$countyname, 
                            c("St Charles"="St. Charles","St Clair"="St. Clair",
                              "St Francois"="St. Francois",
                              "St Louis"="St. Louis","St Louis City"="St. Louis city",
                              "Ste Genevieve"="Ste. Genevieve","Dekalb"="DeKalb"
                              ))
###MERGE 
merge_MO<- merge(x = shape, y = MO_covid_noKan, by = "countyname", all = TRUE)
merge415 <- subset(merge_MO,ï»¿date=='2020/4/15')
merge_MO$cases[is.na(merge_MO$cases)] <- 0
max(merge_MO$cases)
min(merge_MO$cases)
##TIME SERIES
MO_covid_415 <- subset(merge_MO, ï»¿date=='2020/4/15')
MO_covid_508 <- subset(merge_MO, ï»¿date=='2020/5/8')
###MAP
windows(9,7)
tm_shape(MO_covid_508) +
  tm_polygons("cases",style="fixed" , breaks=c(0,10,100,500,1000,2000,3700))