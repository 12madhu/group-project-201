# sources data.R file with data wrangling
source("data.R")

ui <- navbarPage(theme = shinytheme("cerulean"), 
                 "Audio Features: Top 100",
                 
                # tab with histograms for each audio feature  
                 tabPanel("Features",
                          sidebarLayout(
                              sidebarPanel(
                                  
                                  # select box to select specific feature
                                  selectInput("select1", label = h3("Choose an Audio Feature"), 
                                              choices = list("Danceability" = "danceability", "Energy"="energy", "Key"="key", "Loudness"= "loudness", "Mode" ="mode", "Speechiness"= "speechiness", "Acousticness" = "acousticness", 
                                                     "Instrumentalness"="instrumentalness", "Liveness"="liveness", "Valence"="valence", "Tempo"="tempo", "Duration (ms)"="duration_ms", "Time Signature"="time_signature"),
                                                  #features,
                                              selected = "Danceability" ),
                                  
                                  p("The histogram displays trends in different audio features for the Top 100 Tracks of 2017 on Spotify."),
                                  
                                  # radio buttons to choose plot
                                  radioButtons("radio", label = h3("Histogram or Linear"),
                                               choices = list("Histogram" = "plot1","Point Plot" = "plot"), 
                                               selected = "plot1")
                              ),
                              
                              mainPanel(
                                  uiOutput("heading1"),
                                  plotOutput("plot1"),
                                  textOutput("text1"),
                                  br(),
                                  p("Higher ranked songs tend to have both high levels of danceability and energy. This means that they can easily be danced to and that they are fairly fast and loud. 
                                    Songs within the top ten also tend to have low levels of speechiness and acousticness. 
                                    This makes sense as most popular songs have a balance of music, vocals, instruments, and editing.
                                    These songs are generally very positive which can be seen by their higher levels of valence. 
                                    However, it should be noted that these trends do not exclusively mean that popular songs will precisely follow them. 
                                    This can be seen in the point plot as many songs even within the top ten tend to vary greatly between each other.")
                              )
                          )
                 ),
                
                # tab for bar charts for each song
                 tabPanel("Songs",
                          sidebarLayout(
                              sidebarPanel(
                                  
                                  # select box to select a song
                                  selectInput("select2", label = h3("Choose a Song:"),
                                              choices = songs,
                                              selected = "Shape of You"),
                                  
                                  uiOutput("songs"),
                                  br(),
                                  p("It is important to note that the reputation of the artist, timing of the release and numerous other factors (not just the audio features) would also
                                  have influenced where on the Top 100 the song would end up.")
                                  
                              ),
                              
                              mainPanel(
                                  uiOutput("heading2"),
                                  p("The bar chart below shows the levels of each audio feature for the selected song: "),
                                  plotOutput("plot2"),
                                  textOutput("text2"),
                                  br(),
                                  p("The trend that appears in all of these songs is a relatively high energy and loudness while speechiness, instrumentalness, liveness, and tempo remain low. 
                                    There are many songs that differ in variance and key indicating that they are not as important as energy and speechiness. 
                                    The clearest trend was that all songs tended to have high levels of danceability.")
                              )
                          )
                 ),
                
                # tab with bar charts for artist who appear more than once 
                 tabPanel("Artists",
                          sidebarLayout(
                              sidebarPanel(
                                  
                                  # select box to choose specific artist
                                  selectInput("select3", label = h3("Choose an Artist:"),
                                              choices = artists,
                                              selected = "Bruno Mars"),
                                  
                                  checkboxInput("checkbox", label = "View Artist's Top Songs", value = FALSE),
                                  
                                  uiOutput("image"),
                                  br(),
                                  p("Each artist on this list has multiple songs on the Top 100 Tracks of 2017 on Spotify.
                                   The audio feature values represented on the bar chart are a summations of each audio feature across all their songs in the Top 100.
                                   Looking at this chart we can doa  partial analysis on what audio features may have contributed to the popularity of these songs.
                                    However it is important to note that the reputation of the artist, timing of the release and numerous other factors could also
                                    have influenced where on the Top 100 the song would end up and whether it is on this list at all.")
                              ),
                              mainPanel(
                                  uiOutput("heading3"),
                                  p("The bar chart below shows the levels of each audio feature for all the selected artist's songs: "),
                                  plotOutput("plot3"),
                                  uiOutput("heading4"),
                                  textOutput("artist"),
                                  br(),
                                  p("A trend that can be seen is similar values in the key and loudness of the songs of these popular
                                    artists. The key the track is in integers map to pitches using standard Pitch Class notation.
                                    E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on. While the overall loudness of a track in decibels (dB). 
                                    Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks. 
                                    Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). 
                                    Values typical range between -60 and 0 db. The values of these audio features are high across all the popular
                                    artists regardless of their style of music. The genres range from Reggaeton to EDM, yet these two features
                                    are the most prominent.")
                              )
                          )
                 ),
                
                 # tab to display correlations between audio features
                 tabPanel("Correlations",
                          sidebarLayout(
                              sidebarPanel( 
                                  
                                  # radio buttons to choose visualization type
                                   radioButtons("vis", "Select a Visual Type:",
                                               c("Square" = "square", "Circle" = "circle", "Coefficient" = "number")),
                                   
                                  # check boxes to choose features to analyze
                                  checkboxGroupInput("features", "Select Features to Correlate:",
                                                     choices = select.options, #list("Danceability" = "danceability", "Energy"="energy", "Key"="key", "Loudness"= "loudness", "Mode" ="mode", "Speechiness"= "speechiness", "Acousticness" = "acousticness", 
                                                                  #  "Instrumentalness"="instrumentalness", "Liveness"="liveness", "Valence"="valence", "Tempo"="tempo", "Duration (ms)"="duration_ms", "Time Signature"="time_signature"), 
                                                     selected = select.options,
                                                     inline = FALSE, width = NULL)
                              ),
                              mainPanel(
                                  plotOutput("corrplot"),
                                  br(),
                                  textOutput("info"), 
                                  br(),
                                  textOutput("summary")
                              )
                          )
                 ),
                
                # tab for information on chosen artist: Drake
                 tabPanel("Spotify Spotlight",
                          sidebarLayout(
                              sidebarPanel(
                                  
                                  h4("Introduction"),
                                  uiOutput("Drake"),
                                  br(),
                                  tags$div(img(src = "Drake.jpeg",width = 250, height = 250)),
                                  br(),
                                  paste("\"In less than half a decade, the Toronto-born rapper 
                                        Drake went from being a former child actor and Lil Wayne’s protegé to one of 
                                        the world’s biggest entertainers. The indelible pop hooks and bleeding-heart lyricism found on his early albums, 
                                        especially 2010’s Thank Me Later and 2011’s Take Care, won him legions of fans and plenty of scorn. A year after
                                        releasing his most successful album to date, 2016’s VIEWS, Drake offered up what he termed a \"playlist\" 
                                        instead of a traditional album, More Life, on which he embraced more diasporic musical influences like 
                                        South African house and tropicália.\"")
    
                              ),
                              
                              mainPanel(
                                  h4("Spotify Spotlight Artist: Drake"),
                                  plotOutput("plotDrake"),
                                  textOutput("DrakeInfo")
                              )
                          )
                 )
                 
)




