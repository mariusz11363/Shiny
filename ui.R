#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shinydashboard)
library(shiny)
library(plotly)

# Define UI for application that draws a histogram

a1 <- "Temperature"
a2 <- "Max temperature"
a3 <- "Min temperature"
a4 <- "Wind 10m"
a5 <- "Wind 30m"
a6 <- "Wind 60m"
a7 <- "Gust max"
a8 <- "Cape"
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(a1, tabName = "dashboard1", icon = icon("dashboard")),
    menuItem(a2, tabName = "dashboard2", icon = icon("dashboard")),
    menuItem(a3, tabName = "dashboard3", icon = icon("dashboard")),
    menuItem(a4, tabName = "dashboard4", icon = icon("dashboard")),
    menuItem(a5, tabName = "dashboard5", icon = icon("dashboard")),
    menuItem(a6, tabName = "dashboard6", icon = icon("dashboard")),
    menuItem(a7, tabName = "dashboard7", icon = icon("dashboard")),
    menuItem(a8, tabName = "dashboard8", icon = icon("dashboard")),
    menuItem("Chart", icon = icon("th"), tabName = "widgets",
             badgeLabel = "new", badgeColor = "green"),
    box(width = 15,
        title = "Animation", status = "primary", solidHeader = T,
        collapsible = TRUE,
        sliderInput("bins", "Looping Animation:",
                    min = 100, max = 120,
                    value = 1, step = 1,
                    animate =
                      animationOptions(interval = 800, loop = T))
        
    )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard1",h2(a1)),
    tabItem(tabName = "dashboard2",h2(a2)),
    tabItem(tabName = "dashboard3",h2(a3)),
    tabItem(tabName = "dashboard4",h2(a4)),
    tabItem(tabName = "dashboard5",h2(a5)),
    tabItem(tabName = "dashboard6",h2(a6)),
    tabItem(tabName = "dashboard7",h2(a7)),
    
    tabItem(tabName = "dashboard8",
            h2(a8),

            
            
            plotOutput("distPlot" , width = "100%"),
            br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
            uiOutput("czas")
            
            
    ),
    
    tabItem(tabName = "widgets",
            h2("Chart"),
            box(
                title = a1, status = "success", solidHeader = T,
                collapsible = T,
            plotOutput("widget_temp")),
            box(title = a2, status = "success", solidHeader = T,
                collapsible = T,
                plotOutput("widget_temp_max")),
            box(title = a3,status = "success", solidHeader = T,
                 collapsible = T,
                plotOutput("widget_temp_min")),
            box(title = a4,status = "success", solidHeader = T,
                collapsible = T,
                plotOutput("widget_wind_10m"))
            
            
            
            
            
            
    )
  )
)

# Put them together into a dashboardPage
dashboardPage(
  dashboardHeader(title = "Meteo"),
  sidebar,
  body
)
