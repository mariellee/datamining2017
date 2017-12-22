imdb1 <- read.csv("c:/kool/andmekaeve/movies_project/Data/imdb/imdb_data1.csv")
imdb2 <- read.csv("c:/kool/andmekaeve/movies_project/Data/imdb/idmb_data2.csv")
imdb3 <- read.csv("c:/kool/andmekaeve/movies_project/Data/imdb/imdb_data3.csv")

library(dplyr)

imdb1$critics_count[is.na(imdb1$critics_count)] = 0
imdb1$review_count[is.na(imdb1$review_count)] = 0


data <- rbind(imdb1, imdb2, imdb3)
important_data <- data %>% filter(!is.na(rating))

important_data$critics_count[is.na(important_data$critics_count)] = 0
important_data$review_count[is.na(important_data$review_count)] = 0

important_data <- important_data %>% select(-X)

write.csv(important_data, file="c:/kool/andmekaeve/movies_project/Data/imdb/imdb_data.csv")
