load("SXtemp.Rdata")

require(dplyr)
library(shiny)
library(shinydashboard)
library(xts)
library(dygraphs)

cities = unique(SXtemp$city)
counties = unique(SXtemp$county)



# SIDE BAR
sidebar <- dashboardSidebar(


  sidebarMenu(
  menuItem("Temperature Trend", tabName = "TempTrend"),
  selectInput("city", label = "City:",
              choices = cities,
              selected = "datong"),
  selectInput("county", label = "County:",
              choices = NULL),
  dateRangeInput("daterange", "Date range:",
                 start  = "2013-01-01",
                 end    = "2017-11-28",
                 min    = "2013-01-01",
                 max    = "2017-11-28",
                 format = "yy/mm/dd",
                 separator = " - "),
  checkboxGroupInput("temperature", "Temperature:",
                     choices = c("Max" = "tmax",
                                 "Average" = "tmed",
                                 "Min" = "tmin"),
                     selected = c("tmax", "tmed", "tmin"))#,
  #menuItem("Temperature variation", tabName = "TempVariation")
  ),
  br(),
  img(src='SLUlogo.png', style="display: block; margin-left: auto; margin-right: auto;", width = 180)
)

# BODY
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "TempTrend",
            fluidRow(
              dygraphOutput("SXtrend"),
              br(),
              dygraphOutput("SXvariation")))
  )
)




ui <- dashboardPage(
  dashboardHeader(title = "Analyzing Temperature Patterns in Shanxi, China",
                  titleWidth = 470),
  sidebar,
  body
)

server <- function(input, output, session) {

  observeEvent(input$city, {
    updateSelectInput(session,'county',
                      choices=unique(SXtemp$county[SXtemp$city==input$city]),
                      selected = unique(SXtemp$county[SXtemp$city==input$city])[1])
  })


  fildata = reactive({
    SXtemp %>%
      filter(city == input$city,
             county == input$county,
             date >= input$daterange[1],
             date <= input$daterange[2]) %>%
      arrange(date)
  })


  output$SXtrend <- renderDygraph({

    fildata() %>%
      select(!!unlist(input$temperature)) %>%
      xts(., order.by = fildata()$date) %>%
      dygraph(main = paste("Temperatures trends at",
                            input$county, "County, ", input$city,
                            "City, Shanxi, China, ", input$daterange[1],
                            "to", input$daterange[2],
                           sep = " "),
              y = "Temperature in Fahrenheits",
              group = "temperat") %>%
      dyAxis("x", drawGrid = FALSE) %>%
      dyOptions(axisLineColor = "navy",
                gridLineColor = "lightblue") %>%
      dyLegend(width = 400)

  })


  output$SXvariation <- renderDygraph({

    fildata() %>%
      select(tvarv, tvarh) %>%
      xts(., order.by = fildata()$date) %>%
      dygraph(main = paste("Temperatures variation at",
                           input$county, "County, ", input$city,
                           "City, Shanxi, China, ", input$daterange[1],
                           "to", input$daterange[2],
                           sep = " "),
              y = "Temperature variation in Fahrenheits",
              group = "temperat") %>%
      dySeries("tvarv", label = "Vertical variation", color = "orange") %>%
      dySeries("tvarh", label = "Horizontal variation", color = "green") %>%
      dyOptions(axisLineColor = "navy",
                gridLineColor = "lightblue") %>%
      dyAxis("x", drawGrid = FALSE) %>%
      dyLegend(width = 400) %>%
      dyRangeSelector()

  })



}

# Run the application
shinyApp(ui = ui, server = server)



