movie_genres <- read.csv("C:/kool/andmekaeve/movies_project/Data/movie set kaggle/genre_movie.csv")
genres <- read.csv("C:/kool/andmekaeve/movies_project/Data/movie set kaggle/genres.csv")
ratings_fail <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/ratings_small.csv")

library(dplyr)


#THIS IS THE MOST IMPORTANT LINE. THE ID VALUE SAYS WHICH PERSON ARE WE RECOMMENDING TO
user_ratings <- ratings_fail %>% filter(userId == 2)
user_ratings$rating <- user_ratings$rating * 2
write.csv(user_ratings, file="C:/kool/andmekaeve/movies_project/Data/movie set kaggle/sample_input.csv")



# ratings will give weights for tags
# weight = (rating - 5 / 2)

weights <- data.frame(id = genres$id, weight= rep(0, length(genres)))

for (i in c(1:nrow(user_ratings))) {
  user_rating_id <- user_ratings[i,2]
  rating <- user_ratings[i,3]
  weight <- (rating - 5) / 2
  movie_data <- movie_genres %>% filter (movie_id == user_rating_id)
  if (nrow(movie_data) != 0) {
    genre_ids <- movie_data$genre_id
    for (genre_id in as.numeric(as.character(genre_ids))) {
      genre <- (genres %>% filter (genre_id == id))$id
      row_nr <- which(weights[,1] == genre)
      weights[row_nr, 2] <- weights[row_nr, 2] + weight
    }
  }
}


meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
movies <- meta_data %>% select(id, title)

scores = c()
movie_ids <- movies$id
for (m_id in movie_ids) {
  genre_ids <- (movie_genres %>% filter (movie_id == m_id))$genre_id
  size <- length(genre_ids)
  score <- 0
  for (g_id in genre_ids) {
    score <- score + (weights %>% filter(id == g_id))$weight / size
  }
  scores <- c(scores, score)
}
movies$prediction_score <- scores

write.csv(movies, file="C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_genre_out.csv")


rm(list=ls()) #clearing memory
