#######################
# Connect to MySQL DB #
#######################
install.packages("RMySQL")
library(RMySQL)

mydb = dbConnect(
  MySQL(), 
  user='admin', 
  password='OBSLCLZOQHRBYCCA', 
  dbname='MSDS7330_final_project', 
  host='sl-us-south-1-portal.6.dblayer.com',
  port=23884
)




########
# Maps #
########
install.packages("rworldmap")
library(rworldmap)

CountryGDP2000 <- dbGetQuery(mydb, 'SELECT Country, GDPGrowth FROM raw_clean WHERE Year=2000')
print(CountryGDP2000)


mapped_data <- joinCountryData2Map(CountryGDP2000, joinCode = "NAME", nameJoinColumn = "Country")

LowGDP2000 <- dbGetQuery(mydb, "SELECT GDPGrowth FROM raw_clean WHERE Year=2000 AND GDPGrowth IS NOT NULL ORDER BY GDPGrowth ASC LIMIT 1")

HighGDP2000 <- dbGetQuery(mydb, "SELECT GDPGrowth FROM raw_clean WHERE Year=2000 ORDER BY GDPGrowth DESC LIMIT 1")


par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(
  mapped_data, 
  nameColumnToPlot = "GDPGrowth", 
  mapTitle = "GDP Growth: 10yr Ending 2000",
  colourPalette = c("red","green"),
  numCats = 2,
  catMethod = c(-12:15),
  missingCountryCol = "grey",
  oceanCol='lightblue'
)


CountryGDP_TopBottom <- dbGetQuery(mydb, "SELECT Country, GDPGrowth FROM raw_clean WHERE Country IN ('China','Ireland', 'St.Kitts and Nevis', 'Burundi', 'Comoros', 'Russian Federation') AND Year=2000")
mapped_TopBottom <- joinCountryData2Map(CountryGDP_TopBottom, joinCode = "NAME", nameJoinColumn = "Country")
par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(
  mapped_TopBottom, 
  nameColumnToPlot = "GDPGrowth", 
  mapTitle = "GDP Growth: 2000", 
  missingCountryCol = "white", 
  numCats = 2, 
  colourPalette = c("red","green"),
  oceanCol='lightblue',
  addLegend='FALSE'
)
addMapLegendBoxes(
  title = "10yr Period Ending 2000",
  colourVector = c("red", "green"),
  x = "bottomleft",
  col = "black",
  legendText = c("Lowest", "Highest")
)


#Country maps
library(maps)
library(ggmap)

# China
Export_China <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
FROM raw_trade_clean
                           WHERE Reporter = 'China' AND
                           Partner NOT IN ('...', 'World', 'China') AND
                           Indicator_Type IN ('Export') AND 
                           Indicator IN ('Trade (US$ Mil)-Top 5 Export Partner') AND
                             Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                           Value IS NOT NULL")
Import_China <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
FROM raw_trade_clean
                           WHERE Reporter = 'China' AND
                           Partner NOT IN ('...', 'World', 'China') AND
                           Indicator_Type IN ('Import') AND 
                           Indicator IN ('Trade (US$ Mil)-Top 5 Import Partner') AND
 Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                           Value IS NOT NULL")

mapped_Export_China <- joinCountryData2Map(Export_China, joinCode = "NAME", nameJoinColumn = "Partner")
mapped_Import_China <- joinCountryData2Map(Import_China, joinCode = "NAME", nameJoinColumn = "Partner")
ChinaExport <- mapCountryData(
  mapped_Export_China, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "China Export Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 1, 
  colourPalette = c("red","red"),
  oceanCol='lightblue',
  addLegend='FALSE'
) 

ChinaImport <- mapCountryData(
  mapped_Import_China, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "China Import Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 1, 
  colourPalette = c("blue","blue"),
  oceanCol='lightblue',
  addLegend='FALSE'
) 


# Ireland
Export_Ireland <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                           FROM raw_trade_clean
                           WHERE Reporter = 'Ireland' AND
                           Partner NOT IN ('...', 'World', 'Ireland') AND
                           Indicator_Type IN ('Export') AND 
                           Indicator IN ('Trade (US$ Mil)-Top 5 Export Partner') AND
                           Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                           Value IS NOT NULL")
Import_Ireland <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                           FROM raw_trade_clean
                             WHERE Reporter = 'Ireland' AND
                             Partner NOT IN ('...', 'World', 'Ireland') AND
                             Indicator_Type IN ('Import') AND 
                             Indicator IN ('Trade (US$ Mil)-Top 5 Import Partner') AND
                             Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                             Value IS NOT NULL")

mapped_Export_Ireland <- joinCountryData2Map(Export_Ireland, joinCode = "NAME", nameJoinColumn = "Partner")
mapped_Import_Ireland <- joinCountryData2Map(Import_Ireland, joinCode = "NAME", nameJoinColumn = "Partner")

par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(
  mapped_Export_Ireland, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "Ireland Export Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("red","red"),
  oceanCol = 'lightblue',
  addLegend='FALSE'
)
mapCountryData(
  mapped_Import_Ireland, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "Ireland Import Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("blue","blue"),
  oceanCol = 'lightblue',
  addLegend='FALSE'
)


# St.Kitts and Nevis
Export_StKitts <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                           FROM raw_trade_clean
                           WHERE Reporter = 'St. Kitts and Nevis' AND
                           Partner NOT IN ('...', 'World', 'St. Kitts and Nevis') AND
                           Indicator_Type IN ('Export') AND 
                           Indicator IN ('Trade (US$ Mil)-Top 5 Export Partner') AND
                          Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                           Value IS NOT NULL")
Import_StKitts <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                           FROM raw_trade_clean
                           WHERE Reporter = 'St. Kitts and Nevis' AND
                           Partner NOT IN ('...', 'World', 'St. Kitts and Nevis') AND
                           Indicator_Type IN ('Import') AND 
                           Indicator IN ('Trade (US$ Mil)-Top 5 Import Partner') AND
                          Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                           Value IS NOT NULL")

mapped_Export_StKitts <- joinCountryData2Map(Export_StKitts, joinCode = "NAME", nameJoinColumn = "Partner")
mapped_Import_StKitts <- joinCountryData2Map(Import_StKitts, joinCode = "NAME", nameJoinColumn = "Partner")

par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(
  mapped_Export_StKitts, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "St.Kitts and Nevis Export Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("red","red"),
  oceanCol = 'lightblue',
  addLegend='FALSE'
)
mapCountryData(
  mapped_Import_StKitts, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "St.Kitts and Nevis Import Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("blue","blue"),
  oceanCol = 'lightblue',
  addLegend='FALSE'
)


# Burundi
Export_Burundi <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                             FROM raw_trade_clean
                             WHERE Reporter = 'Burundi' AND
                             Partner NOT IN ('...', 'World', 'Burundi') AND
                             Indicator_Type IN ('Export') AND 
                             Indicator IN ('Trade (US$ Mil)-Top 5 Export Partner') AND
                          Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                             Value IS NOT NULL")
Import_Burundi <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                             FROM raw_trade_clean
                             WHERE Reporter = 'Burundi' AND
                             Partner NOT IN ('...', 'World', 'Burundi') AND
                             Indicator_Type IN ('Import') AND 
                             Indicator IN ('Trade (US$ Mil)-Top 5 Import Partner') AND
                          Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                             Value IS NOT NULL")

mapped_Export_Burundi <- joinCountryData2Map(Export_Burundi, joinCode = "NAME", nameJoinColumn = "Partner")
mapped_Import_Burundi <- joinCountryData2Map(Import_Burundi, joinCode = "NAME", nameJoinColumn = "Partner")

par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(
  mapped_Export_Burundi, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "Burundi Export Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("red","red"),
  oceanCol='lightblue',
  addLegend='FALSE'
)
mapCountryData(
  mapped_Import_Burundi, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "Burundi Import Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("blue","blue"),
  oceanCol = 'lightblue',
  addLegend='FALSE'
)

# Comoros
Export_Comoros <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                             FROM raw_trade_clean
                             WHERE Reporter = 'Comoros' AND
                             Partner NOT IN ('...', 'World', 'Comoros') AND
                             Indicator_Type IN ('Export') AND 
                             Indicator IN ('Trade (US$ Mil)-Top 5 Export Partner') AND
                          Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                             Value IS NOT NULL")
Import_Comoros <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                             FROM raw_trade_clean
                             WHERE Reporter = 'Comoros' AND
                             Partner NOT IN ('...', 'World', 'Comoros') AND
                             Indicator_Type IN ('Import') AND 
                             Indicator IN ('Trade (US$ Mil)-Top 5 Import Partner') AND
                          Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                             Value IS NOT NULL")

mapped_Export_Comoros <- joinCountryData2Map(Export_Comoros, joinCode = "NAME", nameJoinColumn = "Partner")
mapped_Import_Comoros <- joinCountryData2Map(Import_Comoros, joinCode = "NAME", nameJoinColumn = "Partner")

par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(
  mapped_Export_Comoros, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "Comoros Export Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("red","red"),
  oceanCol='lightblue',
  addLegend='FALSE'
)
mapCountryData(
  mapped_Import_Comoros, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "Comoros Import Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("blue","blue"),
  oceanCol='lightblue',
  addLegend='FALSE'
)


# Russia
Export_Russia <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                             FROM raw_trade_clean
                             WHERE Reporter = 'Russian Federation' AND
                             Partner NOT IN ('...', 'World', 'Russian Federation') AND
                             Indicator_Type IN ('Export') AND 
                             Indicator IN ('Trade (US$ Mil)-Top 5 Export Partner') AND
                          Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                             Value IS NOT NULL")
Import_Russia <- dbGetQuery(mydb, "SELECT DISTINCT Partner, Indicator_Type
                             FROM raw_trade_clean
                            WHERE Reporter = 'Russian Federation' AND
                            Partner NOT IN ('...', 'World', 'Russian Federation') AND
                            Indicator_Type IN ('Import') AND 
                            Indicator IN ('Trade (US$ Mil)-Top 5 Import Partner') AND
                            Year IN (2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991) AND
                            Value IS NOT NULL")

mapped_Export_Russia <- joinCountryData2Map(Export_Russia, joinCode = "NAME", nameJoinColumn = "Partner")
mapped_Import_Russia <- joinCountryData2Map(Import_Russia, joinCode = "NAME", nameJoinColumn = "Partner")

par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(
  mapped_Export_Russia, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "Russia Export Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("red","red"),
  oceanCol='lightblue',
  addLegend='FALSE'
)
mapCountryData(
  mapped_Import_Russia, 
  nameColumnToPlot = "Indicator_Type",
  mapTitle = "Russia Import Partners", 
  missingCountryCol = "white",
  catMethod = 'categorical',
  numCats = 2, 
  colourPalette = c("blue","blue"),
  oceanCol='lightblue',
  addLegend='FALSE'
)


##############
# Trade Data #
##############
library(ggplot2)


#China
Trade_China <- read.table(header=TRUE, text='Reporter Partner Indicator_Type Year USMil 
China	World	Export	1992	84940.0100
China	World	Import	1992	80585.3000
                          China	World	Export	1993	91743.9400
                          China	World	Import	1993	103958.9400
                          China	World	Export	1994	121006.2600
                          China	World	Import	1994	115613.6100
                          China	World	Export	1995	148779.5000
                          China	World	Import	1995	132083.5000
                          China	World	Export	1996	151047.4500
                          China	World	Import	1996	138832.7400
                          China	World	Export	1996	151047.4500
                          China	World	Import	1996	138832.7400
                          China	World	Export	1997	182791.5900
                          China	World	Import	1997	142370.3200
                          China	World	Export	1998	183808.9800
                          China	World	Import	1998	140236.7700
                          China	World	Export	1999	194930.7800
                          China	World	Import	1999	165699.0700
                          China	World	Export	2000	249202.5500
                          China	World	Import	2000	225093.7300
                          China	World	Export	1992	84940.0100
                          China	World	Import	1992	80585.3000
                          China	World	Export	1993	91743.9400
                          China	World	Import	1993	103958.9400
                          China	World	Export	1994	121006.2600
                          China	World	Import	1994	115613.6100
                          China	World	Export	1995	148779.5000
                          China	World	Import	1995	132083.5000
                          China	World	Export	1996	151047.4500
                          China	World	Import	1996	138832.7400
                          China	World	Export	1996	151047.4500
                          China	World	Import	1996	138832.7400
                          China	World	Export	1997	182791.5900
                          China	World	Import	1997	142370.3200
                          China	World	Export	1998	183808.9800
                          China	World	Import	1998	140236.7700
                          China	World	Export	1999	194930.7800
                          China	World	Import	1999	165699.0700
                          China	World	Export	2000	249202.5500
                          China	World	Import	2000	225093.7300')
ggplot(Trade_China, aes(factor(Year), USMil, fill = Indicator_Type)) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "China Trade")

#Ireland
Trade_Ireland <- read.table(header=TRUE, text='Reporter Partner Indicator_Type Year USMil 
Ireland	World	Export	1992	28334.5300
Ireland	World	Import	1992	22482.6900
                          Ireland	World	Export	1993	28856.5100
                          Ireland	World	Import	1993	21662.9900
                          Ireland	World	Export	1994	34395.1200
                          Ireland	World	Import	1994	25763.8200
                          Ireland	World	Export	1995	43789.3400
                          Ireland	World	Import	1995	32321.0200
                          Ireland	World	Export	1996	45565.3500
                          Ireland	World	Import	1996	35764.6500
                          Ireland	World	Export	1996	45565.3500
                          Ireland	World	Import	1996	35764.6500
                          Ireland	World	Export	1997	53619.6500
                          Ireland	World	Import	1997	39232.6700
                          Ireland	World	Export	1998	64246.9300
                          Ireland	World	Import	1998	44378.0100
                          Ireland	World	Export	1999	71226.7300
                          Ireland	World	Import	1999	47207.8400
                          Ireland	World	Export	2000	76261.8800
                          Ireland	World	Import	2000	50648.7700
                          Ireland	World	Export	1992	28334.5300
                          Ireland	World	Import	1992	22482.6900
                          Ireland	World	Export	1993	28856.5100
                          Ireland	World	Import	1993	21662.9900
                          Ireland	World	Export	1994	34395.1200
                          Ireland	World	Import	1994	25763.8200
                          Ireland	World	Export	1995	43789.3400
                          Ireland	World	Import	1995	32321.0200
                          Ireland	World	Export	1996	45565.3500
                          Ireland	World	Import	1996	35764.6500
                          Ireland	World	Export	1996	45565.3500
                          Ireland	World	Import	1996	35764.6500
                          Ireland	World	Export	1997	53619.6500
                          Ireland	World	Import	1997	39232.6700
                          Ireland	World	Export	1998	64246.9300
                          Ireland	World	Import	1998	44378.0100
                          Ireland	World	Export	1999	71226.7300
                          Ireland	World	Import	1999	47207.8400
                          Ireland	World	Export	2000	76261.8800
                          Ireland	World	Import	2000	50648.7700')
ggplot(Trade_Ireland, aes(factor(Year), USMil, fill = Indicator_Type)) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Ireland Trade")

#St.Kitts & Nevis
#Had to change name so 'text' could read country name
Trade_StKitts <- read.table(header=TRUE, text='Reporter Partner Indicator_Type Year USMil 
St.KittsandNevis	World	Export	1993	26.9200
St.KittsandNevis	World	Import	1993	117.9200
                          St.KittsandNevis	World	Export	1994	22.2700
                          St.KittsandNevis	World	Import	1994	127.1400
                          St.KittsandNevis	World	Export	1995	18.7800
                          St.KittsandNevis	World	Import	1995	132.2600
                          St.KittsandNevis	World	Export	1996	21.5200
                          St.KittsandNevis	World	Import	1996	145.8500
                          St.KittsandNevis	World	Export	1996	21.5200
                          St.KittsandNevis	World	Import	1996	145.8500
                          St.KittsandNevis	World	Export	1997	41.0700
                          St.KittsandNevis	World	Import	1997	147.1700
                          St.KittsandNevis	World	Export	1999	27.9300
                          St.KittsandNevis	World	Import	1999	152.7700
                          St.KittsandNevis	World	Export	2000	32.5800
                          St.KittsandNevis	World	Import	2000	195.7300
                          St.KittsandNevis	World	Export	1993	26.9200
                          St.KittsandNevis	World	Import	1993	117.9200
                          St.KittsandNevis	World	Export	1994	22.2700
                          St.KittsandNevis	World	Import	1994	127.1400
                          St.KittsandNevis	World	Export	1995	18.7800
                          St.KittsandNevis	World	Import	1995	132.2600
                          St.KittsandNevis	World	Export	1996	21.5200
                          St.KittsandNevis	World	Import	1996	145.8500
                          St.KittsandNevis	World	Export	1996	21.5200
                          St.KittsandNevis	World	Import	1996	145.8500
                          St.KittsandNevis	World	Export	1997	41.0700
                          St.KittsandNevis	World	Import	1997	147.1700
                          St.KittsandNevis	World	Export	1999	27.9300
                          St.KittsandNevis	World	Import	1999	152.7700
                          St.KittsandNevis	World	Export	2000	32.5800
                          St.KittsandNevis	World	Import	2000	195.7300')
ggplot(Trade_StKitts, aes(factor(Year), USMil, fill = Indicator_Type)) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "St.Kitts & Nevis Trade")

#Burundi
Trade_Burundi <- read.table(header=TRUE, text='Reporter Partner Indicator_Type Year USMil 
Burundi	World	Export	1993	158.2600
Burundi	World	Import	1993	221.2100
Burundi	World	Export	1994	171.6000
Burundi	World	Import	1994	203.3400
Burundi	World	Export	1995	178.9400
Burundi	World	Import	1995	270.4900
Burundi	World	Export	1996	81.7800
Burundi	World	Import	1996	139.8000
Burundi	World	Export	1996	81.7800
Burundi	World	Import	1996	139.8000
Burundi	World	Export	1997	68.7400
Burundi	World	Import	1997	120.5700
Burundi	World	Export	1998	86.5000
Burundi	World	Import	1998	162.2300
Burundi	World	Export	1999	62.4100
Burundi	World	Import	1999	131.9700
Burundi	World	Export	2000	42.8500
Burundi	World	Import	2000	150.2200
Burundi	World	Export	1993	158.2600
Burundi	World	Import	1993	221.2100
Burundi	World	Export	1994	171.6000
Burundi	World	Import	1994	203.3400
Burundi	World	Export	1995	178.9400
Burundi	World	Import	1995	270.4900
Burundi	World	Export	1996	81.7800
Burundi	World	Import	1996	139.8000
Burundi	World	Export	1996	81.7800
Burundi	World	Import	1996	139.8000
Burundi	World	Export	1997	68.7400
Burundi	World	Import	1997	120.5700
Burundi	World	Export	1998	86.5000
Burundi	World	Import	1998	162.2300
Burundi	World	Export	1999	62.4100
Burundi	World	Import	1999	131.9700
Burundi	World	Export	2000	42.8500
Burundi	World	Import	2000	150.2200')
ggplot(Trade_Burundi, aes(factor(Year), USMil, fill = Indicator_Type)) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Burundi Trade")

#Comoros
Trade_Comoros <- read.table(header=TRUE, text='Reporter Partner Indicator_Type Year USMil 
Comoros	World	Export	1995	11.0200
Comoros	World	Import	1995	62.3900
Comoros	World	Export	1996	6.1400
Comoros	World	Import	1996	56.6400
Comoros	World	Export	1996	6.1400
Comoros	World	Import	1996	56.6400
Comoros	World	Export	1997	5.6300
Comoros	World	Import	1997	55.0300
Comoros	World	Export	1998	3.9400
Comoros	World	Import	1998	46.9500
Comoros	World	Export	1999	4.6500
Comoros	World	Import	1999	79.8500
Comoros	World	Export	2000	7.1800
Comoros	World	Import	2000	36.2800
Comoros	World	Export	1995	11.0200
Comoros	World	Import	1995	62.3900
Comoros	World	Export	1996	6.1400
Comoros	World	Import	1996	56.6400
Comoros	World	Export	1996	6.1400
Comoros	World	Import	1996	56.6400
Comoros	World	Export	1997	5.6300
Comoros	World	Import	1997	55.0300
Comoros	World	Export	1998	3.9400
Comoros	World	Import	1998	46.9500
Comoros	World	Export	1999	4.6500
Comoros	World	Import	1999	79.8500
Comoros	World	Export	2000	7.1800
Comoros	World	Import	2000	36.2800')
ggplot(Trade_Comoros, aes(factor(Year), USMil, fill = Indicator_Type)) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Comoros Trade")

#Russia
#Had to change name so 'text' could read country name
Trade_Russia <- read.table(header=TRUE, text='Reporter Partner Indicator_Type Year USMil 
RussianFederation	World	Export	1996	88703.0000
RussianFederation	World	Import	1996	61147.0000
                           RussianFederation	World	Export	1996	88703.0000
                           RussianFederation	World	Import	1996	61147.0000
                           RussianFederation	World	Export	1997	87368.0000
                           RussianFederation	World	Import	1997	67619.0000
                           RussianFederation	World	Export	1998	72275.5900
                           RussianFederation	World	Import	1998	43711.3400
                           RussianFederation	World	Export	1999	74662.9600
                           RussianFederation	World	Import	1999	40428.9500
                           RussianFederation	World	Export	2000	103092.7500
                           RussianFederation	World	Import	2000	33880.0900
                           RussianFederation	World	Export	1996	88703.0000
                           RussianFederation	World	Import	1996	61147.0000
                           RussianFederation	World	Export	1996	88703.0000
                           RussianFederation	World	Import	1996	61147.0000
                           RussianFederation	World	Export	1997	87368.0000
                           RussianFederation	World	Import	1997	67619.0000
                           RussianFederation	World	Export	1998	72275.5900
                           RussianFederation	World	Import	1998	43711.3400
                           RussianFederation	World	Export	1999	74662.9600
                           RussianFederation	World	Import	1999	40428.9500
                           RussianFederation	World	Export	2000	103092.7500
                           RussianFederation	World	Import	2000	33880.0900')
ggplot(Trade_Russia, aes(factor(Year), USMil, fill = Indicator_Type)) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Russia Trade")


