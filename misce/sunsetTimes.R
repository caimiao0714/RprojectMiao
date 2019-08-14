# Import data
#rawData <- fread("2015-5-COLORED COLS.csv")
#sampleData <- rawData[1:2000,]
#save(sampleData, file ="SampleData.RData")

load("sampleData.RData")

sampleData2 <- sampleData %>%
  select(begDate, EndTime, fromlat, fromLon) %>%
  mutate(begDate = as.Date(begDate, format = '%m/%d/%Y'),
         EndTime = as.Date(EndTime, format = '%m/%d/%Y'),
         fromlat = round(fromlat, digits = 2),
         fromLon = round(fromLon, digits = 2)) 

test <- sampleData2 %>%
  mutate(date = begDate, lat = fromlat, lon = fromLon) %>%
  select(date, lat, lon) 
a <- Sys.time()
test2 <- getSunlightTimes(data = test,
                          tz= "CT",
                          keep = c("sunrise", "sunriseEnd", "sunset", "sunsetStart"))
b <- Sys.time()
b-a

# 2 sec = 2000 obs
# 17 mins = 1M obs

#LESSON LEARNED: To pass in a data frame, you must use the colnames: date, lat, lon


