meta <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/metascores.csv")
crew <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_crew_out.csv")
genre <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_genre_out.csv")
tags <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_tags_out.csv")
meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
other_people <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/similar_people_out.csv")
                     
merged <- merge(meta, meta_data, by="imdb_id") 
merged$original_title <- merged$original_title.x
meta <- merged %>% select (id, original_title, prediction_score)

input <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/input.csv")
meta <- meta %>% filter (!id %in% input$movieId)

result <- data.frame(id = meta$id, title = meta$original_title, score = meta$prediction_score)

crew$prediction_score <- 2 * crew$prediction_score
tags$prediction_score <- tags$prediction_score / 3
other_people$predicton_score <- other_people$predicton_score / 100


for (row_nr in c(1:nrow(result))) {
  id <- result[row_nr, 1]
  score <- result[row_nr, 3]
  
  crew_row <- which(crew[,2] == id)
  if (length(crew_row == 1)) {
    score <- score + crew[crew_row, 4]
  }
  
  genre_row <- which(genre[,2] == id)
  if (length(genre_row == 1)) {
    score <- score + genre[genre_row, 4]
  }
  
  tags_row <- which(tags[,2] == id)
  if (length(tags_row == 1)) {
    score <- score + tags[tags_row, 4]
  }
    
  others_row <- which(other_people[,2] == id)
  if (length(others_row == 1)) {
    score <- score + other_people[others_row, 4]
  }
  
  result[row_nr, 3] <- score
}


write.csv(result, file="C:/kool/andmekaeve/movies_project/recommendation_system/samples/general_out.csv")

rm(list=ls()) #clearing memory
