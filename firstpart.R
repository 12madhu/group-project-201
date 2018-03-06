library(tidyr)
library(dplyr)
library("ggplot2")
library(corrplot)
library("tibble")

songs <- read.csv("featuresdf.csv", stringsAsFactors=FALSE) 
songs$rank <- 1:100

######
###### QUESTION 1
######

ggplot(data = songs, mapping = aes(x = rank, y = tempo, color = duration_ms, size = instrumentalness)) +
  geom_point() +
  geom_smooth(se=FALSE)

ggplot(data = songs, mapping = aes(x = rank, y = instrumentalness)) +
  geom_point() +
  geom_smooth(se=FALSE)

ggplot(data = songs, mapping = aes(x = rank, y = liveness)) +
  geom_point() +
  geom_smooth(se=FALSE)

ggplot(data = songs, mapping = aes(x = rank, y = valence)) +
  geom_point() +
  geom_smooth(se=FALSE)

ggplot(data = songs, mapping = aes(x = rank, y = tempo)) +
  geom_point() +
  geom_smooth(se=FALSE)

ggplot(data = songs, mapping = aes(x = rank, y = duration_ms)) +
  geom_point() +
  geom_smooth(se=FALSE)

# Check out the lm() model, it might be similar to what we've done, but feel free to check.
