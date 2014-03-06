#use Ting part
source("Stations.R")

stations <- Stations$new() 
results <- xmlEventParse(
    file="http://api.wunderground.com/api/b340be89948f3793/geolookup/q/CA/San_Francisco.xml",
    branches = stations$saxHandler())

stationList <- stations$stations()[5:6,"Id"]


##Ben part so far

source("getWeather.R")

weather <- getWeather$new() 
getWResults <- xmlEventParse(
  file="http://api.wunderground.com/api/b340be89948f3793/history_20140304/q/pws:KCASANFR58.xml",
  branches = weather$saxHandler())

weather$observations()
