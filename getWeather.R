library(XML)

getWeather <- setRefClass("getWeather",
                          fields = list(weatherData = "data.frame"))

getWeather$methods(
  initialize=function() {
    .self$weatherData <- data.frame(
      hour=character(),
      min=character(),
      tempm=numeric(),
      wspdm=numeric()
      )
  },
  
  observations = function() {
    colnames(weatherData) <<-
      c("hour", "min", "tempm", "wspdm") 
    weatherData
  },
  
  saxHandler = function() {
    weatherData <<- data.frame(
      hour=character(),
      min=character(),
      tempm=numeric(),
      wspdm=numeric()
      )
    observation <- function(context, node) {
      newdata <- data.frame(
        xmlValue(node[["date"]][["hour"]]),
        xmlValue(node[["date"]][["min"]]),
        as.numeric(xmlValue(node[["tempm"]])),
        as.numeric(xmlValue(node[["wspdm"]]))
        )
      weatherData <<- rbind(weatherData, newdata)
    }
    c(observation = xmlParserContextFunction(observation))
  }
)
