input <- read.csv("C:/kool/andmekaeve/movies_project/Data/movie set kaggle/sample_input.csv")
input <- input %>% select (-X)
movie_tags <- read.csv("C:/kool/andmekaeve/movies_project/Data/movie set kaggle/tag_movie.csv")
tags <- read.csv("C:/kool/andmekaeve/movies_project/Data/movie set kaggle/tags.csv")

library(dplyr)


weights <- data.frame(id = tags$id, weight= rep(0, length(tags)))


for (i in c(1:nrow(input))) {
  m_id <- input[i,2]
  rating <- input[i,3]
  weight <- (rating - 5) / 2
  movie_data <- movie_tags %>% filter (id_movie == m_id)
  if (nrow(movie_data) != 0) {
    keyword_ids <- movie_data$id_keyword
    for (keyword_id in as.numeric(as.character(keyword_ids))) {
      row_nr <- which(weights[,1] == keyword_id)
      weights[row_nr, 2] <- weights[row_nr, 2] + weight
    }
  }
}


meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
movies <- meta_data %>% select(id, title)

scores = c()
movie_ids <- movies$id
for (m_id in movie_ids) {
  tag_ids <- (movie_tags %>% filter (id_movie == m_id))$id_keyword
  size <- length(tag_ids)
  score <- 0
  for (t_id in tag_ids) {
    score <- score + (weights %>% filter(id == t_id))$weight / size
  }
  scores <- c(scores, score)
}
movies$prediction_score <- scores

write.csv(movies, file="C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_tags_out.csv")


rm(list=ls()) #clearing memory
