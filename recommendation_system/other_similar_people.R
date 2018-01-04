input <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/input.csv")
library(dplyr)
input <- input %>% select (-X)
input <- input %>% filter (movieId != 12347)

ratings <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/ratings.csv")
ratings$rating <- ratings$rating * 2

meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
meta_data <- meta_data %>% select(id, title)
meta_data$predicton_score <- rep(0, nrow(meta_data))


suitable <- ratings %>% filter (movieId %in% input$movieId)

users <- unique(suitable$userId)

for (user in users){
  user_ratings <- ratings %>% filter (userId == user)
  closeness <- 0
  for (rating_row in c(1:nrow(user_ratings))) {
    m_id <- user_ratings[rating_row, 2]
    for (my_rating_row in c(1:nrow(input))) {
        my_m_id <- input[my_rating_row, 2]
        if (m_id == my_m_id) {
          u_rating <- user_ratings[rating_row, 3]
          my_rating <- input[my_rating_row, 3]
          if (u_rating == my_rating) {
            closeness <- closeness + 1
          } else if (abs(u_rating - my_rating == 1)) {
            closeness <- closeness + 0.5
          } else if (abs(u_rating - my_rating > 2)) {
            closeness <- closeness - (abs(u_rating - my_rating) / 5)
          }
        }
    }
  }
  if (closeness > 0) {
      for (rating_row in c(1:nrow(user_ratings))) {
        m_id <- user_ratings[rating_row, 2]
        m_rating <- user_ratings[rating_row, 3]
        score <- closeness * m_rating / 10
        row_nr <- which(meta_data[,1] == m_id)
        meta_data[row_nr, 3] <- meta_data[row_nr, 3] + score
      }
  }
}

#movies <- movies %>% filter (!id %in% input$movieId)

rm(list=ls()) #clearing memory
