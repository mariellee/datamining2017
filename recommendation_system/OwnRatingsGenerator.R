metascores <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/metascores.csv")
metadata <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
metadata <- metadata %>% select (id, title)

input <- read.csv("C:/kool/andmekaeve/movies_project/Data/movie set kaggle/sample_input.csv")

movie_ids <- c(155, 13, 11, 12347, 211672, 16538, 131631)
ratings <- c(10, 6, 4, 8, 9, 7, 10)

my_id <- 1111110

output <- data.frame(userId = rep(my_id, length(ratings)), movieId = movie_ids, rating = ratings)
write.csv(output, file="C:/kool/andmekaeve/movies_project/recommendation_system/samples/input.csv")

rm(list=ls()) #clearing memory
