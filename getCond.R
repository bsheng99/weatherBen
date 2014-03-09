getCond <- function(startDt, endDt, stationdata) {
  numStations <- nrow(stationdata)
  dateSeq <- seq(as.Date(startDt),to=as.Date(endDt),by="days")
  
  stationList <- list()
  length(stationList) <- numStations
  
  for (i in 1:numStations) {
    conditionData <- data.frame()
    for (j in 1:length(dateSeq)) {
      webid <- paste("http://api.wunderground.com/api/b340be89948f3793/history_", 
                     format(as.Date(dateSeq[j]), "%Y%m%d"), "/q/pws:", 
                     stationdata[i, "Id"], ".xml", sep="")      
      doc <- xmlTreeParse(file=webid, useInternal=TRUE)
      top <- xmlRoot(doc)  
      newData <- data.frame(
        unlist(xpathApply(top, "//observation/date/year", xmlValue)),
        unlist(xpathApply(top, "//observation/date/mon", xmlValue)),
        unlist(xpathApply(top, "//observation/date/mday", xmlValue)),
        unlist(xpathApply(top, "//observation/date/hour", xmlValue)),
        unlist(xpathApply(top, "//observation/date/min", xmlValue)),
        unlist(xpathApply(top, "//observation/utcdate/year", xmlValue)),
        unlist(xpathApply(top, "//observation/utcdate/mon", xmlValue)),
        unlist(xpathApply(top, "//observation/utcdate/mday", xmlValue)),
        unlist(xpathApply(top, "//observation/utcdate/hour", xmlValue)),
        unlist(xpathApply(top, "//observation/utcdate/min", xmlValue)),
        unlist(xpathApply(top, "//observation/tempm", xmlValue)),
        unlist(xpathApply(top, "//observation/dewptm", xmlValue)),
        unlist(xpathApply(top, "//observation/hum", xmlValue)),
        unlist(xpathApply(top, "//observation/wspdm", xmlValue)),
        unlist(xpathApply(top, "//observation/wgustm", xmlValue)),
        unlist(xpathApply(top, "//observation/wdird", xmlValue)),
        unlist(xpathApply(top, "//observation/pressurem", xmlValue)),
        unlist(xpathApply(top, "//observation/windchillm", xmlValue)),
        unlist(xpathApply(top, "//observation/heatindexm", xmlValue)),
        unlist(xpathApply(top, "//observation/precip_ratem", xmlValue)),
        unlist(xpathApply(top, "//observation/precip_totalm", xmlValue))
      )
      conditionData <- rbind(conditionData, newData)
    }
    colnames(conditionData) <-
      c("lYr", "lMonth", "lDay", "lHr", "lMin", 
        "uYr", "uMonth", "uDay", "uHr", "uMin", 
        "tempC", "dewptC", "hum%", "windKm", "wgustKm", "wdirDeg",
        "pressureMb", "wchillC", "hindexC", "precip_rateMm", "precip_totMm") 
    stationList[[i]] <- conditionData
  } 
  names(stationList) <- paste(stationdata[1:numStations, "Id"])
  
  return(stationList)
}
