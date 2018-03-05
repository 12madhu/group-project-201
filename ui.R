library(tidyr)
library(dplyr)
library("ggplot2") 
library("shiny")
library(rsconnect)

songs <- read.csv("featuresdf.csv", stringsAsFactors=FALSE) 
features <- colnames(songs[-c(1, 2, 3)]) 

my.ui <- navbarPage("Our group project!!!",
           tabPanel("Plot",
                    sidebarLayout(
                      sidebarPanel( 
                        radioButtons("vis", "Select a Visual Type:",
                                     c("Square" = "square", "Circle" = "circle", "Coefficient" = "number")),
                        checkboxGroupInput("features", "Select Features to Correlate:",
                                           choices = features, selected = features,
                                           inline = FALSE, width = NULL)
                      ),
                      mainPanel(
                        plotOutput("corrplot"), 
                        verbatimTextOutput("info"), 
                        verbatimTextOutput("summary")
                      )
                    )
           )
)
