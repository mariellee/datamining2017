input <- read.csv("C:/kool/andmekaeve/movies_project/Data/movie set kaggle/sample_input.csv")
input <- input %>% select (-X)
#crew_names <- read.csv("C:/kool/andmekaeve/movies_project/Data/movie set kaggle/actors_first_5.csv")
movie_crew <- read.csv("C:/kool/andmekaeve/movies_project/Data/movie set kaggle/movie_actor_first_5.csv")

library(dplyr)


weights <- data.frame(id = movie_crew$actor_id, weight= rep(0, length(movie_crew)))
weights <- weights[!duplicated(weights), ]

for (i in c(1:nrow(input))) {
  m_id <- input[i,2]
  rating <- input[i,3]
  weight <- (rating - 5) / 2
  movie_data <- movie_crew %>% filter (movie_id == m_id)
  if (nrow(movie_data) != 0) {
    crew_ids <- movie_data$actor_id
    for (member in as.numeric(as.character(crew_ids))) {
      row_nr <- which(weights[,1] == member)
      weights[row_nr, 2] <- weights[row_nr, 2] + weight
    }
  }
}


meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
movies <- meta_data %>% select(id, title)

scores = c()
movie_ids <- movies$id
for (m_id in movie_ids) {
  crew_ids <- (movie_crew %>% filter (movie_id == m_id))$actor_id
  score <- 0
  for (person in crew_ids) {
    score <- score + (weights %>% filter(id == person))$weight / 5
  }
  scores <- c(scores, score)
}
movies$prediction_score <- scores

write.csv(movies, file="C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_crew_out.csv")


rm(list=ls()) #clearing memory
