# sources data.R file with data wrangling
source("data.R")

server <- function(input, output) {
    
    # outputs logo
    output$logo <- renderUI({
        tags$div(img(src = "logo.jpeg", width = 380, height = 240))
    })
    
    
    # provides description for each audio feature when selected
    output$text1 <- renderPrint({
            description <- column.data %>% filter(input$select1 == columnname) %>%
                                                    select(description)
            paste(description)
    
    })
    
    # creates heading for histogram
    output$heading1 <- renderUI({
        h4(str_to_title(input$select1))
    })
    
    # creates histograms or line/point plot for each audio feature based on select box input
    # change to histogram or line/point plot based on radio buttons
    output$plot1 <- renderPlot({
        if(input$radio == "plot1"){
        ggplot(data = song.data, aes(song.data[ ,input$select1])) + 
            geom_histogram(color = "white", fill = "pink"  ) + 
                stat_function(fun = dnorm,args = list(mean = mean(song.data[ ,input$select1]), sd = sd(song.data[ ,input$select1])), col = "black") +
                    labs(x = str_to_title(input$select1), y = "Count")
        }else{
            ggplot(data = song.data, mapping = aes(x = position, y = song.data[ ,input$select1]), binwidth = 0.001) +
                geom_point() +
                geom_smooth(se = FALSE)
        }
    })
    
    # creates heading for songs tab
    output$heading2 <- renderUI({
        h4(str_to_title(input$select2))
    })
    
    # creates bar charts for each song and their audio features based on select box input
    output$plot2 <- renderPlot({
        song.data$name <- factor(song.data$name)
        song.data.long <- gather(song.data,feature, level, danceability:time_signature, factor_key=TRUE)
        song <- song.data.long %>% filter(name == input$select2)
        ggplot(data = song, aes(x = str_to_title(feature),y = level) ) + 
            geom_bar(stat = "identity", position = "dodge", color = "white", fill = "pink" ) +
            labs(x = "Features", y = "Count") + theme(axis.text.x= element_text(angle = 45, margin = margin(t = 20)))
    })
    
    # prints the rank of the chosen song
    output$text2 <- renderText({
        rank <- song.data %>% filter(input$select2 == name)
        rank <- rank[,"position"]
        paste(input$select2, "holds the number", rank, "spot on the Top 100 Tracks of 2017 on Spotify") 
    })
    
    # creates heading for artists tab
    output$heading3 <- renderUI({
        h4(input$select3)
    })
    
    # creates bar charts for artists with more than one song on the charts
    # based on select box input
    output$plot3 <- renderPlot({
        summed.dup.artists$artists <- factor(summed.dup.artists$artists)
        summed.dup.artists.long <- gather(summed.dup.artists,feature, level, danceability:time_signature, factor_key=TRUE)
        artist <- summed.dup.artists.long %>% filter(artists == input$select3)
        ggplot(data = artist, aes(x = str_to_title(feature), y = level)) + 
            geom_bar(stat = "identity", position = "dodge", color = "white", fill = "pink" ) + 
            labs(x = "Features", y = "Count") + theme(axis.text.x= element_text(angle = 45, margin = margin(t = 20)))
    })
    
    # creates heading for top songs of chosen artist
    output$heading4 <- renderUI({
        if  (input$checkbox == TRUE){
            h5("Artists Songs on Top 100:")
        }
        
    })
    
    # prints chosen artists songs on the top tracks 2017
    output$artist <- renderText({
        if (input$checkbox == TRUE){
            artists.songs <- song.data %>% filter(artists == input$select3)
            artists.songs <- artists.songs[, "name"]
            paste0(artists.songs, collapse = ", ")
        }
    })
    
    # outputs artist image based on select box in artists tab
    output$image <- renderUI({
        tags$div(img(src = paste0(input$select3,".jpeg"),width = 250, height = 250))
    })
    
    # creates reactive variable
    features.selected <- reactive({ 
        return (input$features)
    })
    
    # creates reactive variable
    visual.selected <- reactive({ 
        return (input$vis)
    }) 
    
    # outputs correlation between audio features based on radio buttons and check boxes
    output$corrplot <- renderPlot({   
        songs.for.corr <- song.data[-c(1, 2, 3)]
        colnames(songs.for.corr) <- c("Danceability", "Energy", "Key", "Loudness", "Mode", "Speechiness", "Acousticness", 
                                      "Instrumentalness", "Liveness", "Valence", "Temp", "Duration (ms)", "Time Signature")
        filter.subset <- select(songs.for.corr, features.selected())            
        filtered.correlation <- cor(filter.subset, use="all.obs", method="kendall") 
        visual.filtered <- corrplot(filtered.correlation, method=visual.selected(), col = brewer.pal(n = 8, name = "RdPu"), 
                                    tl.col = "black")
        return (visual.filtered)
    }) 
    
    # creates hyperlink to Top Tracks 2017 spotify playlist
    output$songs <- renderUI({
        url <- a("Top Tracks 2017", href="https://open.spotify.com/user/spotify/playlist/37i9dQZF1DX5nwnRMcdReF?si=ucdHecy1RquVJyPG1mK8ww")
        tagList("Listen now:", url)
    })
    
    # outputs image in spotify spotlight tab
    output$Drake <- renderUI({
        url <- a("This is Drake", href="https://open.spotify.com/user/spotify/playlist/37i9dQZF1DX7QOv5kjbU68?si=5QeLOcOSQfGj2kFCNjSBPA")
        tagList("Listen now:", url)
    })
    
    # prints what view the user has chosen 
    output$info <- renderText({
        paste0("You are currently viewing this graph using the ", visual.selected(), " view.") 
    })
    
    # summarizes our correlation visualization
    output$summary <- renderText({
        paste0("Through this correlation table, we can see that there is little correlation between the music features. 
                The feature that had the most correlation was energy and loudness, which is unsurprising since we often associate loud music with high energy events. The second greatest
                correlation was between valence and energy -- which is also unsurprising since we typically have more energy when we are happy. 
                That said, we found it surprising that there is not a greater correlation between dancebility and energy or liveliness and energy.") 
    })
     
    # creates bar chart for all fo Drakes songs and their audio features   
    output$plotDrake <- renderPlot({
        summed.dup.artists$artists <- factor(summed.dup.artists$artists)
        summed.dup.artists.long <- gather(summed.dup.artists,feature, level, danceability:time_signature, factor_key=TRUE)
        artist <- summed.dup.artists.long %>% filter(artists == "Drake")
        ggplot(data = artist, aes(x = str_to_title(feature), y = level)) + 
            geom_bar(stat = "identity", position = "dodge", color = "white", fill = "pink" ) + 
            labs(x = "Features", y = "Count") + theme(axis.text.x= element_text(angle = 45, margin = margin(t = 20)))
    })
    
    # provides information on chosen artist: Drake
    output$DrakeInfo <- renderText({
        paste0(" \n Drake has created a sound and brand for his music. If you've heard Drake's music, you can recall the distinct 
               aura and sound created by his voice and his beats. In 2017, he had three songs on Spotify's 2017 Top Tracks: Passionfruit, One Dance, and Fake love. 
               One characteristic of his music is his rapping, so we expected to see similar Speechiness scores for these three songs; however, only 
               Passionfruit and One Dance were similar whereas Fake Love had a higher Speechiness score by ~0.4. This shows that people love Drake's music, 
               whether or not he raps (and therefore increasing Speechiness) in them. On the other hand, Danceability scores for 
               these songs were also in a close range of 0.7-0.9). Other similar feature scores across all three songs include Energy and Liveliness. 
               Overall, these results lead us to conclude that one reason people love Drake's music is because it is easy to dance too. A varied Speechiness 
               score reminds us that it isn't just rapping that makes Drake's unique sound -- it is the combination of his 
               lyrical genius, beats, and artistic freedom that capture fans from across the world. We acknowledge that these 
               are only three of Drake's many musical hits and that we are forming conclusions based off of these three songs. 
               \n Source: https://pitchfork.com/artists/27950-drake/")   
    }) 
}  

