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
print(length(users))
counter <-  1

for (user in users){
  print(counter)
  counter <- counter + 1
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
      maximum <- max(user_ratings$rating, na.rm = TRUE)
      liked <-  user_ratings %>% filter (rating == maximum)
      for (i in c(1:nrow(liked))) {
        m_id <- liked[i,2]
        m_rating <- liked[i,3]
        r_row <- which(meta_data[,1] == m_id)
        score <- closeness*maximum /10
        meta_data[r_row, 3] <- score + meta_data[r_row, 3]
      }
  }
}

write.csv(meta_data, file="C:/kool/andmekaeve/movies_project/recommendation_system/samples/similar_people_out.csv")


rm(list=ls()) #clearing memory
