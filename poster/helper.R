# making data frame for showing user input
input <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/input.csv")
meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
meta_data <- meta_data %>% select (id, original_title)

titles <- c()
ids <- input$movieId

for (m_id in ids) {
  row <- meta_data %>% filter (id == m_id)
  title <-  as.character(row[1,2])
  print(title)
  titles <- c(titles, title)
}

input$title <- titles
input <- input %>% filter (movieId != 12347)

input <- input %>% select(title, rating)


#making data frame for showing top meta_scores
meta_scores <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/metascores.csv")
meta_scores <- meta_scores %>% arrange(desc(prediction_score))
meta_scores <- meta_scores %>% top_n (5) %>% select (original_title, prediction_score)
colnames(meta_scores) <- c("title", "prediction_score")

#making the data frame from top crew recommendations
crew <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_crew_out.csv")
crew <- crew %>% arrange(desc(prediction_score))


#making the data frame from top genre recommendations
genre <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_genre_out.csv")
genre <- genre %>% arrange(desc(prediction_score))
genre <- genre %>% select (title, prediction_score)

#making the data frame from top tags recommendations
tags <- read.csv("C:/kool/andmekaeve/movies_project/recommendation_system/samples/ratings_and_genre_out.csv")
tags <- tags %>% arrange(desc(prediction_score))
tags <- tags %>% select (title, prediction_score)


# making general recommendations
general <- csv.read("C:/kool/andmekaeve/movies_project/recommendation_system/samples/general_out.csv")

