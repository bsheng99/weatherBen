library(XML)
library(ggplot2)
library(gridExtra)


##Ting code
source("q1.R")
location <- c(37.786289,-122.405234)
dist_km <- 10
stationdata <- Stations(location, dist_km)


##Ben code
source("getCond3.R")
startDt <- "2014-02-09"
endDt <- "2014-02-09"
weatherCond <- getCond(startDt, endDt, stationdata)


#get weather conditions for a given time
#just take first obs for now
subsetCond <- data.frame()
for (i in 1:nrow(stationdata)) {
  subsetCond <- rbind(subsetCond, 
                      weatherCond[[i]][1, c("tempC", "humPer", "windKm", 
                                            "wdirDeg", "pressureMb", "precip_rateMm")])
}

#combine with station location
subCondPws <- cbind(stationdata[, c("Id", "Lat", "Lon")], subsetCond)
subCondPws <- subCondPws[rowSums(is.na(subCondPws)) == 0,]

#plot
ggTemp <- ggplot(subCondPws, aes(Lon, Lat))
ggTemp <- ggTemp + geom_point(aes(colour = tempC))
ggHum <- ggplot(subCondPws, aes(Lon, Lat))
ggHum <- ggHum + geom_point(aes(colour = humPer))
ggWSpeed <- ggplot(subCondPws, aes(Lon, Lat))
ggWSpeed <- ggWSpeed + geom_point(aes(colour = windKm))
ggWDir <- ggplot(subCondPws, aes(Lon, Lat))
ggWDir <- ggWDir + geom_point(aes(colour = wdirDeg))
ggPres <- ggplot(subCondPws, aes(Lon, Lat))
ggPres <- ggPres + geom_point(aes(colour = pressureMb))
ggPrec <- ggplot(subCondPws, aes(Lon, Lat))
ggPrec <- ggPrec + geom_point(aes(colour = precip_rateMm))

#output
pdf("microclimate1.pdf")
grid.arrange(ggTemp, ggHum, ggWSpeed, ggWDir, ggPres, ggPrec, nrow=3, ncol=2)
dev.off()
