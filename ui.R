# Nick's part

# Define UI
ui <- navbarPage(theme = shinytheme("cerulean"),
                 "Audio Features: Top 100",
                 # creates a tab to display a table     
                 tabPanel("Features",
                          sidebarLayout(
                            sidebarPanel(
                              
                              selectInput("select1", label = h3("Audio Features"),
                                          choices = features,
                                          selected = "danceability")
                            ),
                            
                            mainPanel(
                              plotOutput("plot1")
                            )
                          )
                 ),
                 tabPanel("Songs",
                          sidebarLayout(
                            sidebarPanel(
                              
                              selectInput("select2", label = h3("Songs"),
                                          choices = songs,
                                          selected = "Shape of You")
                            ),
                            mainPanel(
                              plotOutput("plot2")
                            )
                          )
                 ),
                 tabPanel("Artists",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("select3", label = h3("Artists"),
                                          choices = artists,
                                          selected = "Bruno Mars")
                            ),
                            mainPanel(
                              plotOutput("plot3")
                            )
                          )
                 ),
                 tabPanel("Correlations",
                          sidebarLayout(
                            sidebarPanel(
                              radioButtons("radio", label = h3("Correlations"),
                                           choices = list("speechiness vs. danceability vs. tempo" = "visual.filtered", "All audio features" = "visual.all"), 
                                           selected = "All audio features")
                            ),
                            mainPanel(
                              plotOutput("plot4")
                            )
                          )
                 )
                 
)