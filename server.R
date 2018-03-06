library("reshape2")
library("tidyr")
source("data.R")

server <- function(input, output) {
    
    output$text1 <- renderPrint({
            description <- column.data %>% filter(input$select1 == columnname) %>%
                                                    select(description)
            paste(description)
            
    })
    
    output$heading1 <- renderUI({
        h4(input$select1)
    })
    output$plot1 <- renderPlot({
        if(input$radio == "plot1"){
        ggplot(data = song.data, aes(song.data[ ,input$select1])) + 
            geom_histogram(color = "white", fill = "pink"  ) + 
            # change to fitdistr
                stat_function(fun = dnorm,args = list(mean = mean(song.data[ ,input$select1]), sd = sd(song.data[ ,input$select1])), col = "black") +
                    labs(x = input$select1, y = "Count")
        }else{
            ggplot(data = song.data, mapping = aes(x = position, y = song.data[ ,input$select1]), binwidth = 0.001) +
                geom_point() +
                geom_smooth(se=FALSE)
        }
    })
    
    output$plot2 <- renderPlot({
        song.data$name <- factor(song.data$name)
        song.data.long <- gather(song.data,feature, level, danceability:time_signature, factor_key=TRUE)
        song <- song.data.long %>% filter(name == input$select2)
        ggplot(data = song, aes(x = feature,y = level), binwidth = 0.001 ) + 
            geom_bar(stat = "identity", position = "dodge", color = "white", fill = "pink" ) +
            labs(title = "Songs", x = "Features", y = "Count") 
       
        # add description about top song and include other factors that may have led to this
        # acknowledge other factors like timing and reputation of the artist matter
    })
    
    output$text2 <- renderText({
        rank <- song.data %>% filter(input$select2 == name)
        rank <- rank[,"position"]
        paste(input$select2, "holds the number", rank, "spot on the Top 100 Tracks of 2017 on Spotify") 
    })
    output$plot3 <- renderPlot({
        summed.dup.artists$artists <- factor(summed.dup.artists$artists)
        summed.dup.artists.long <- gather(summed.dup.artists,feature, level, danceability:time_signature, factor_key=TRUE)
        artist <- summed.dup.artists.long %>% filter(artists == input$select3)
        ggplot(data = artist, aes(x = feature, y = level), binwidth = 0.001) + 
            geom_bar(stat = "identity", position = "dodge", color = "white", fill = "pink" ) + 
            labs(title = "Artists", x = "Features", y = "Count") 
        # add description about top song and include other factors that may have led to this
        # acknowledge other factors like timing and reputation of the artist matter
    })
    
    output$heading2 <- renderUI({
        if  (input$checkbox == TRUE){
            h5("Artists Songs on Top 100:")
        }
        
    })
    
    output$artist <- renderText({
        if (input$checkbox == TRUE){
            artists.songs <- song.data %>% filter(artists == input$select3)
            artists.songs <- artists.songs[, "name"]
            paste0(artists.songs, collapse = ", ")  
        }
        
    })
    
    features.selected <- reactive({ 
        return (input$features)
    })
    
    visual.selected <- reactive({ 
        return (input$vis)
    }) 
    
    # filters data by features selected, then displays their correlation heatmap 
    output$corrplot <- renderPlot({  
        filter.subset <- select(song.data, features.selected())
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

