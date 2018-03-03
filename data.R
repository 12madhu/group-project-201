library("ggplot2")
library("shiny")
library("dplyr")
library(tidyr)
library(dplyr)
library(corrplot)
library("tibble")
library("measurements")
library("shinythemes")
song.data <- read.csv("~/Desktop/group-project-201/featuresdf.csv", stringsAsFactors = FALSE)
songs <- song.data$name
artists <- summed.dup.artists$artists
features <- colnames(song.data[4:16])
song.data$duration_ms <- conv_unit(song.data$duration_ms, "msec", "min" )
song.data$tempo <- song.data$tempo/100


###### QUESTION 3
######

# df of only artists with repeating songs 
dup.artists <- song.data[song.data$artists %in% song.data$artists[duplicated(song.data$artists)],]  

# duplicated artists with summed of all the features.... not sure how we want to further organize this 
summed.dup.artists <-  dup.artists[-c(1, 2)] %>% group_by(artists) %>% summarise_all(sum)  
# bar chart for each artist   


######
###### QUESTION 4 
######
# correlations of all features <--- this may be more interesting than just the three features, so I kept it incase we'll use it! 
all.features.correlation <- cor(song.data[-c(1, 2, 3)], use="all.obs", method="kendall") 

# correlations of speechiness, dancability, tempo 
interest <- c("speechiness", "danceability", "tempo")
filtered.correlation <- cor(song.data[c("speechiness", "danceability", "tempo")], use="all.obs", method="kendall") 

# see other visual options: https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html
visual.all <- corrplot(all.features.correlation, method="color",  col = cm.colors(100))
visual.filtered <- corrplot(filtered.correlation, method="circle",  col = cm.colors(100))
