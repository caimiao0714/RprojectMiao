# spatial notes, eval=FALSE
list.files('data/missouri2017/', pattern='\\.shp$')

# read spatial polygons
sh1 = rgdal::readOGR("data/missouri2017")#YES
sh2 = raster::shapefile("data/missouri2017/Missouri2017.shp") #YES


# read spatial dataframes
df1 = foreign::read.dbf("./data/missouri2017/Missouri2017.dbf")
df2 = sf::read_sf(dsn = "./data/missouri2017/Missouri2017.shp")
df3 = sf::st_read("./data/missouri2017/Missouri2017.shp")
