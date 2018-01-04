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