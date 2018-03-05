library(tidyr)
library(dplyr)
library("ggplot2") 
library("shiny") 
library(rsconnect)
library(RColorBrewer)

my.server <- function(input, output) {
  songs <- read.csv("featuresdf.csv", stringsAsFactors=FALSE) 
  
  features.selected <- reactive({ 
    return (input$features)
  })
  
  visual.selected <- reactive({ 
    return (input$vis)
  }) 
  
  # filters data by features selected, then displays their correlation heatmap 
  output$corrplot <- renderPlot({  
    filter.subset <- select(songs, features.selected())
    filtered.correlation <- cor(filter.subset, use="all.obs", method="kendall") 
    visual.filtered <- corrplot(filtered.correlation, method=visual.selected(), col = brewer.pal(n = 8, name = "PuOr"), 
                                tl.col = "black")
    return (visual.filtered)
  }) 
  
  # prints what view the user has chosen 
  output$info <- renderText({
    paste0("You are currently viewing this graph using the ", visual.selected(), " view.") 
  })
  
  # summarizes our data 
  output$summary <- renderText({
    paste0("I can put a summary of what we see? Basicaly no correlation, the biggest one is _ but mostly it's _ .") 
  })
  
} 