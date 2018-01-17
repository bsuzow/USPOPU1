#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("US Population by State"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      h3("US Population Estimates "),
      h5("as of July 1, 2017"),
      h4("Data Source: The US Census Bureau"),
      br(),
      br(),
      a("Data Source CSV File1", href="https://www2.census.gov/programs-surveys/popest/datasets/2010-2017/state/asrh/scprc-est2017-18+pop-res.csv"),
      br(),
      a("Data Source CSV File2", href="https://www2.census.gov/programs-surveys/popest/tables/2010-2017/state/totals/nst-est2017-03.xlsx"),
      br(),
      a("Estimate Methodology Details", href="https://www2.census.gov/programs-surveys/popest/technical-documentation/methodology/2010-2017/2017-natstcopr-meth.pdf")
    ), # sidebarPanel   
    # Show a plot of the generated distribution
    mainPanel(
       tabsetPanel(type="tabs",
                   tabPanel("All Ages",
                              br(),
                              plotly::plotlyOutput("mapAllPopu")
                           ), # tabPanel - AllPopu

                   tabPanel("% Chg since 2016",
                              br(),
                              plotly::plotlyOutput("mapPctChg")

                           ), # tabPanel - mapChgPct

                   tabPanel("% of Age >= 18",
                              br(),
                              plotly::plotlyOutput("mapOver17pct")    
                              
                           ) # tablPanel - Over17
       ) # tabsetPanel
    ) # mainPanel
  ) # sidebarLayout
  
))                 
