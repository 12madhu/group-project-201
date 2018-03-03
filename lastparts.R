library(tidyr)
library(dplyr)
library("ggplot2")
library(corrplot)
library("tibble")

songs <- read.csv("featuresdf.csv", stringsAsFactors=FALSE) 
songs$duration_ms <- conv_unit(songs$duration_ms, "msec", "min" )
songs$tempo <- songs$tempo/100
######
###### QUESTION 3
######

# df of only artists with repeating songs 
dup.artists <- songs[songs$artists %in% songs$artists[duplicated(songs$artists)],]  

# duplicated artists with summed of all the features.... not sure how we want to further organize this 
summed.dup.artists <-  dup.artists[-c(1, 2)] %>% group_by(artists) %>% summarise_all(sum)  
# bar chart for each artist   


######
###### QUESTION 4 
######
# correlations of all features <--- this may be more interesting than just the three features, so I kept it incase we'll use it! 
all.features.correlation <- cor(songs[-c(1, 2, 3)], use="all.obs", method="kendall") 

# correlations of speechiness, dancability, tempo 
interest <- c("speechiness", "danceability", "tempo")
filtered.correlation <- cor(songs[c("speechiness", "danceability", "tempo")], use="all.obs", method="kendall") 
 
# see other visual options: https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html
visual.all <- corrplot(all.features.correlation, method="circle")
visual.filtered <- corrplot(filtered.correlation, method="circle")
 


