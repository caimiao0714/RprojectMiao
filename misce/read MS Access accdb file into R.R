library(RODBC)

# Example .accdb file from GitHub:
# Source: https://github.com/Access-projects/Access-examples/blob/master/Access_Example_VBA.accdb

#specifies the file path
dta <- odbcConnectAccess2007("C:\\Users\\miaocai\\Downloads\\Access_Example_VBA.accdb")

#loads the tables from CalendarDemo.accdb
CUM_VAL_TB <- sqlFetch(dta, "CUM_VAL_TB")
DECUM_VAL_TB <- sqlFetch(dta, "DECUM_VAL_TB")


# Delete space in variable names and capitalize each word
d = data.frame(matrix(1:8, ncol = 2))
names(d) <- c("treadmill score","aaa bbb")
d

names(d) = gsub(" ", "", tools::toTitleCase(names(d)))
d
