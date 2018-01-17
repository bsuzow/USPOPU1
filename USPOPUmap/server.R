#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# color palettes: https://moderndata.plot.ly/create-colorful-graphs-in-r-with-rcolorbrewer-and-plotly/
#
library(shiny)
library(plotly)

USpopu = read.csv("USpopstates.csv")
USpopu = USpopu %>% mutate(State = sub(".","",State)) %>%
                    mutate(Popu18Pct = Popu18Pct*100) %>%
                    mutate(PctChg = round(PctChg*100,2)) 

shinyServer(function(input, output) {
   
  output$mapAllPopu <- renderPlotly({
     USpopu = USpopu %>% 
        mutate(hoverpop = paste(State,"<br>","Population:",Population))
     
     borders = list(color= toRGB("black"),width=2)
     map_options = list(
        scope="usa",
        projection = list(type='albers usa'),
        showlakes = TRUE,
        lakecolor = toRGB("Light Blue")
     ) 
     
     p = plot_ly(z = ~USpopu$Population,
                 # hoverinfo ="text",
                 text = ~list(USpopu$hoverpop),
                 locations = ~USpopu$Code,
                 type="choropleth",
                 locationmode='USA-states',
                 color=~USpopu$Population,
                 colors="Purples",
                 marker = list(line=borders)) %>%
        colorbar(title = "Population") %>%
        plotly::layout(title='US Population <br>Estimates as of July 2017<br>(Hover for breakdown)', 
                       geo=map_options)
     p
    
  }) # mapAllPopu
  
  output$mapPctChg <- renderPlotly({
    
     USpopu = USpopu %>% 
        mutate(hoverChgPct = paste(State,"<br>","Pop Chg:",PopuChg))
     
     borders = list(color= toRGB("black"),width=2)
     map_options = list(
        scope="usa",
        projection = list(type='albers usa'),
        showlakes = TRUE,
        lakecolor = toRGB("Light Blue")
     ) 
     
     p2 = plot_ly(z = ~USpopu$PctChg,
                  text = ~USpopu$hoverChgPct,
                  locations = ~USpopu$Code,
                  type="choropleth",
                  locationmode='USA-states',
                  color=~USpopu$PctChg,
                  colors="PuBuGn",
                  # hoverinfo="text",
                  marker = list(line=borders)) %>%
        colorbar(title = "Percentage") %>%
        plotly::layout(title='% of Population Change<br>Since July 2016<br>(Hover for breakdown)', 
                       geo=map_options)
     
     p2
     
     
  })  # mapPctChg
  
  output$mapOver17pct <- renderPlotly({
     USpopu = USpopu %>%  
        mutate(hoverpct = paste(State,"<br>","Percentage of Age 18 and older:",Popu18Pct,"%"))
     
     borders = list(color= toRGB("black"),width=2)
     map_options = list(
        scope="usa",
        projection = list(type='albers usa'),
        showlakes = TRUE,
        lakecolor = toRGB("Light Blue")
     ) 
     
     p3 = plot_ly(z = ~USpopu$Popu18Pct,
                  text = ~USpopu$hoverpct,
                  locations = ~USpopu$Code,
                  type="choropleth",
                  locationmode='USA-states',
                  color=~USpopu$Popu18Pct,
                  colors="Reds",
                  # hoverinfo="text",
                  marker = list(line=borders)) %>%
        colorbar(title = "Percentage") %>%
        plotly::layout(title='US Population Percentage of Age 18 or over<br>Estimates as of July 2017<br>(Hover for breakdown)', 
                       geo=map_options)
     
     p3
     
     
  })  # mapOver17pct
  
}) #shinyServer
