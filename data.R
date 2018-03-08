# loads necessary libraries
library("ggplot2")
library("shiny")
library("dplyr")
library("corrplot")
library("tibble")
library("measurements")
library("shinythemes")
library("RColorBrewer")
library("reshape2")
library("tidyr")
library("stringr")

# loads dataset and column metrics dataset
song.data <- read.csv("featuresdf.csv", stringsAsFactors = FALSE)
column.data <- read.csv("columndata.csv", stringsAsFactors = FALSE)

# creates new column with rank
song.data$position <- seq.int(nrow(song.data))

# extracts features, song names and artists
specific.features <- colnames(song.data[-c(1, 2, 3)])
songs <- song.data$name
artists <- summed.dup.artists$artists
features <- colnames(song.data[4:16])

#converts duration from milliseconds to minutes
song.data$duration_ms <- conv_unit(song.data$duration_ms, "msec", "min" )
song.data$tempo <- song.data$tempo/100

# capitalizes column names for formatting
select.options <- c("Danceability", "Energy", "Key", "Loudness", "Mode", "Speechiness", "Acousticness", 
                    "Instrumentalness", "Liveness", "Valence", "Temp", "Duration (ms)", "Time Signature")

# df of only artists with repeating songs 
dup.artists <- song.data[song.data$artists %in% song.data$artists[duplicated(song.data$artists)],]  

# duplicated artists with summed of all the features.... not sure how we want to further organize this 
summed.dup.artists <-  dup.artists[-c(1, 2)] %>% group_by(artists) %>% summarise_all(sum)  


# correlations of all features <--- this may be more interesting than just the three features, so I kept it incase we'll use it! 
all.features.correlation <- cor(song.data[-c(1, 2, 3)], use="all.obs", method="kendall") 

# correlations of speechiness, dancability, tempo 
interest <- c("speechiness", "danceability", "tempo")
filtered.correlation <- cor(song.data[c("speechiness", "danceability", "tempo")], use="all.obs", method="kendall") 



