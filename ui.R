source("data.R")

ui <- navbarPage(theme = shinytheme("cerulean"), 
                 "Audio Features: Top 100",
                 # creates a tab to display a table     
                 tabPanel("Features",
                          sidebarLayout(
                              sidebarPanel(
                                  
                                  selectInput("select1", label = h3("Choose an Audio Feature"), #, class = "audio"),
                                              choices = features,
                                              selected = "danceability"),
                                  p("The histogram displays trends in different audio features for the Top 100 Tracks of 2017 on Spotify:"),
                                  
                                  radioButtons("radio", label = h3("Histogram or Linear"),
                                               choices = list("Histogram" = "plot1","Point Plot" = "plot"), 
                                               selected = "plot1")
                                  
                              ),
                              
                              mainPanel(
                                  uiOutput("heading1"),
                                  plotOutput("plot1"),
                                  textOutput("text1")
                              )
                          )
                 ),
                 tabPanel("Songs",
                          sidebarLayout(
                              sidebarPanel(
                                  
                                  selectInput("select2", label = h3("Choose a song:"),
                                              choices = songs,
                                              selected = "Shape of You"),
                                  p("It is important to note that the reputation of the artist, timing of the release and numerous other factors (not just the audio features) would also
                                  have influenced where on the Top 100 the song would end up."),
                                  p("NOTE: the duration is displayed in minutes")
                              ),
                              mainPanel(
                                  p("The bar chart below shows the levels of each audio feature for the selected song: "),
                                  plotOutput("plot2"),
                                  textOutput("text2")
                              )
                          )
                 ),
                 tabPanel("Artists",
                          sidebarLayout(
                              sidebarPanel(
                                  selectInput("select3", label = h3("Artists"),
                                              choices = artists,
                                              selected = "Bruno Mars"),
                                  
                                  checkboxInput("checkbox", label = "View Artist's Top Songs", value = FALSE),
                                  
                                  p("Each artist on this list has multiple songs on the Top 100 Tracks of 2017 on Spotify.
                                   The audio feature values represented on the bar chart are a summations of each audio feature across all their songs in the Top 100.
                                   Looking at this chart we can partially analyze what audio features may have contributed to the popularity of these songs.
                                    However it is important to note that the reputation of the artist, timing of the release and numerous other factors could also
                                    have influenced where on the Top 100 the song would end up and whether it is on this list at all."),
                                  p("NOTE: the duration is displayed in minutes")
                              ),
                              mainPanel(
                                  p("The bar chart below shows the levels of each audio feature for all the selected artist's songs: "),
                                  plotOutput("plot3"),
                                  uiOutput("heading2"),
                                  textOutput("artist"),
                                  br(),
                                  br(),
                                  p("A trend that can be seen is similar values in the key and loudness of the songs of these popular
                                    artists. The key the track is in integers map to pitches using standard Pitch Class notation.
                                    E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on. While the overall loudness of a track in decibels (dB). 
                                    Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks. 
                                    Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). 
                                    Values typical range between -60 and 0 db.")
                              )
                          )
                 ),
                 
                 tabPanel("Correlations",
                          sidebarLayout(
                              sidebarPanel( 
                                  radioButtons("vis", "Select a Visual Type:",
                                               c("Square" = "square", "Circle" = "circle", "Coefficient" = "number")),
                                  checkboxGroupInput("features", "Select Features to Correlate:",
                                                     choices = specific.features, selected = specific.features,
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
