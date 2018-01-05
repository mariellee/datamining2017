meta <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/metascores.csv")
crew <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_crew_out.csv")
genre <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_genre_out.csv")
tags <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_tags_out.csv")
meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
                     
merged <- merge(meta, meta_data, by="imdb_id") 
merged$original_title <- merged$original_title.x
meta <- merged %>% select (id, original_title, prediction_score)

input <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/input.csv")
meta <- meta %>% filter (!id %in% input$movieId)

result <- data.frame(id = meta$id, title = meta$original_title, score = meta$prediction_score)

crew$prediction_score <- 2 * crew$prediction_score

for (row_nr in c(1:nrow(result))) {
  id <- result[row_nr, 1]
  score <- result[row_nr, 3]
  
  crew_row <- which(crew[,2] == id)
  if (length(crew_row == 1))
    score <- score + crew[crew_row, 4]
  
  result[row_nr, 3] <- score
}
