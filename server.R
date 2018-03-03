library("reshape2")
library("tidyr")
source("data.R")



server <- function(input, output) {
     
    output$plot1 <- renderPlot({
        ggplot(data = song.data, aes(song.data[ ,input$select1])) + 
            geom_histogram(color = "blue", fill = "pink"  ) + 
            # change to fitdistr
                stat_function(fun = dnorm,args = list(mean = mean(song.data[ ,input$select1]), sd = sd(song.data[ ,input$select1])), col = "blue") +
                    labs(title = "Audio Features", x = input$select1, y = "Count") 
        
    })
    
    output$plot2 <- renderPlot({
        song.data$name <- factor(song.data$name)
        song.data.long <- gather(song.data,feature, level, danceability:time_signature, factor_key=TRUE)
        song <- song.data.long %>% filter(name == input$select2)
        ggplot(data = song, aes(x = feature,y = level), binwidth = 0.001 ) + 
            geom_bar(stat = "identity", position = "dodge", color = "blue", fill = "pink" ) +
            labs(title = "Songs", x = "Features", y = "Count") 
        # add description about top song and include other factors that may have led to this
        # acknowledge other factors like timing and reputation of the artist matter
    })
    
    output$plot3 <- renderPlot({
        summed.dup.artists$artists <- factor(summed.dup.artists$artists)
        summed.dup.artists.long <- gather(summed.dup.artists,feature, level, danceability:time_signature, factor_key=TRUE)
        artist <- summed.dup.artists.long %>% filter(artists == input$select3)
        ggplot(data = artist, aes(x = feature, y = level), binwidth = 0.001) + 
            geom_bar(stat = "identity", position = "dodge", color = "blue", fill = "pink" ) + 
            labs(title = "Artists", x = "Features", y = "Count") 
        # add description about top song and include other factors that may have led to this
        # acknowledge other factors like timing and reputation of the artist matter
    })
    
    output$plot4 <- renderPlot({
        # change color???
        if (input$radio == "visual.filtered") {
            visual.filtered <- corrplot(filtered.correlation, method = "circle", col = cm.colors(100))
        } else {
            visual.all <- corrplot(all.features.correlation, method = "color", col = cm.colors(100))
        }
         
    })
    
    
}  

