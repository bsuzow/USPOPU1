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


shinyServer(function(input, output) {
   
   # read the data, change percent field values
   
   USpopu = read.csv("USpopstates.csv")
   USpopu$X = NULL
   USpopu = USpopu %>% 
      mutate(State = as.character(State)) %>%
      mutate(Popu18Pct = Popu18Pct*100) %>%
      mutate(PctChg = round(PctChg*100,2)) 
   
   # compose the stats of the state passed in from UI
   
   StateName = reactive({
     name = USpopu %>% filter(Code== toupper(input$statecode)) %>% select(State)
     name = ifelse(nrow(name)==0,"Incorrect State code entered",name)
     paste0("State: ",name)   
   })
   
   StatePctChg = reactive({
      pctchg = USpopu %>% filter(Code== toupper(input$statecode)) %>% select(PctChg)
      pctchg = ifelse(nrow(pctchg)==0,"N/A",pctchg)
      paste0("% Change since 2016: ", pctchg, "%")
   })
      
   StatePopu   = reactive({
      popu = USpopu %>% filter(Code== toupper(input$statecode)) %>% select(Population)
      popu = round(popu/1000000,3)
      popu = ifelse(nrow(popu)==0,"N/A",popu)
      paste0("Population: ", popu, " M")
      
   }) 
      
   State18Pct  = reactive({
      pct18 = USpopu %>% filter(Code== toupper(input$statecode)) %>% select(Popu18Pct)
      pct18 = ifelse(nrow(pct18)==0,"N/A",pct18)
      paste0("% Population of Age 18 and: ", pct18, "%")
   })
     
   
  # Assign the stats text to the output variable defined in UI
  # ref on renderUI : https://stackoverflow.com/questions/23233497/outputting-multiple-lines-of-text-with-rendertext-in-r-shiny   
  
   output$popuStats = renderUI({
    HTML(paste(StateName(),StatePopu(), StatePctChg(), State18Pct(), sep="<br>"))
   })  # output$stateStats
   
   output$pctchgStats = renderUI({
      HTML(paste(StateName(),StatePopu(), StatePctChg(), sep="<br>"))
   })  # output$stateStats
   
   output$pct18Stats = renderUI({
      HTML(paste(StateName(),StatePopu(), State18Pct(), sep="<br>"))
   })  # output$stateStats
   
  # plot the all population map
  
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
  
  # plot the population change map
  
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
  
  # plot the age >=18 population map
  
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
