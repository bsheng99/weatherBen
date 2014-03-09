library(XML)

#Ting code
source("WeatherStation.R") 
source("q1.R")
location <- c(37.786289,-122.405234)
dist_km <- 1
stationdata <- Stations(location, dist_km)


##Ben code
source("getCond.R")
startDt <- "2014-03-04"
endDt <- "2014-03-06"
weatherCond <- getCond(startDt, endDt, stationdata)

head(weatherCond[[1]])
weatherCond[["KCASANFR231"]][["windKm"]]
