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
        as.numeric(unlist(xpathApply(top, "//observation/date/year", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/date/mon", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/date/mday", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/date/hour", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/date/min", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/utcdate/year", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/utcdate/mon", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/utcdate/mday", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/utcdate/hour", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/utcdate/min", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/tempm", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/dewptm", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/hum", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/wspdm", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/wgustm", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/wdird", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/pressurem", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/windchillm", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/heatindexm", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/precip_ratem", xmlValue))),
        as.numeric(unlist(xpathApply(top, "//observation/precip_totalm", xmlValue)))
      )
      conditionData <- rbind(conditionData, newData)
    }
    colnames(conditionData) <-
      c("lYr", "lMonth", "lDay", "lHr", "lMin", 
        "uYr", "uMonth", "uDay", "uHr", "uMin", 
        "tempC", "dewptC", "humPer", "windKm", "wgustKm", "wdirDeg",
        "pressureMb", "wchillC", "hindexC", "precip_rateMm", "precip_totMm") 
    stationList[[i]] <- conditionData
  } 
  names(stationList) <- paste(stationdata[1:numStations, "Id"])
  
  return(stationList)
}
