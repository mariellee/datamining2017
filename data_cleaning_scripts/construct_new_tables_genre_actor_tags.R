# keywords_single

# Get all single keywords out of list and split it to get id and name, add them to df(id,name) dataset. 
for (j in 1:nrow(keywords)) {
  
  string <- toString(keywords$keywords[j])
  string2 <-  strsplit(string, "[,:]+")
  
  if(length(string2[[1]]) >= 2) {
    
    for (i in seq(2, length(string2[[1]]), by=4)) {
      
      df[nrow(df) + 1,] = c(string2[[1]][i],string2[[1]][i+2])
    }
  }
}

gg <- df %>% distinct(ids,names)

# Remove unnecessary characters 
gg2 <- gg
gg2$names <- gsub("}", "", as.character(gg$names))
gg2$ids <- gsub(" ", "", as.character(gg2$ids))
gg2$names <- gsub("]", "", as.character(gg2$names))
gg2$names <- gsub("'", "", as.character(gg2$names))
gg2$names <- gsub("\"", "", as.character(gg2$names))

# Remove distinct keywords
tag_table <- gg2 %>% distinct(ids,names)
tag_table <- tag_table[-1,]

# Save single keywords to csv file
write.csv(tag_table, file = "C:/Users/Marielle/Downloads/the-movies-dataset/keywords_single.csv", row.names = FALSE)



# Movie_tag

# Create table where keywords are associated to movie id 
# Initialise new dataframe to save id and name values of list 
id_movie <- c(1)
id_keyword <- c(1)
df <-  data.frame(id_movie,id_keyword)

for (j in 1:nrow(keywords)) {
  
  string <- toString(keywords$keywords[j])
  string2 <-  strsplit(string, "[,:]+")
  
  if(length(string2[[1]]) >= 2) {
    
    for (i in seq(2, length(string2[[1]]), by=4)) {
      
      df[nrow(df) + 1,] = c(keywords$id[j],string2[[1]][i])
    }
  }
}


# Remove unnessecary characters
movie_tag <- df
movie_tag$id_keyword <- gsub(" ", "", as.character(movie_tag$id_keyword))
movie_tag <- movie_tag[-1,]

# Save file to csv
write.csv(movie_tag, file = "C:/Users/Marielle/Downloads/the-movies-dataset/keywords_movies.csv", row.names = FALSE)



# Genre

id <- c(1)
name <- c(1)
df <-  data.frame(id,name)

for (j in 1:nrow(movies)) {
  
  string <- toString(movies$genres[j])
  string2 <-  strsplit(string, "[,:]+")
  
  if(length(string2[[1]]) >= 2) {
    
    for (i in seq(2, length(string2[[1]]), by=4)) {
      
      df[nrow(df) + 1,] = c(string2[[1]][i],string2[[1]][i+2])
    }
  }
}


gg2 <- df
gg2$name <- gsub("}", "", as.character(gg2$name))
gg2$id <- gsub(" ", "", as.character(gg2$id))
gg2$name <- gsub("]", "", as.character(gg2$name))
gg2$name <- gsub("'", "", as.character(gg2$name))
gg2$name <- gsub("\"", "", as.character(gg2$name))
genre_table <- gg2 %>% distinct(id,name)
genre_table <- genre_table[-1,]

write.csv(genre_table, file = "C:/Users/Marielle/Downloads/the-movies-dataset/genres_2.csv", row.names = FALSE)


#Genre_movie

movie_id <- c(1)
genre_id <- c(1)
df <-  data.frame(movie_id,genre_id)
movies$id <- as.numeric(movies$id)


for (j in 1:nrow(movies)) {
  
  string <- toString(movies$genres[j])
  string2 <-  strsplit(string, "[,:]+")
  
  if(length(string2[[1]]) >= 2) {
    
    for (i in seq(2, length(string2[[1]]), by=4)) {
      
      df[nrow(df) + 1,] = c(movies$id[j],string2[[1]][i])
    }
  }
}

gg2 <- df
gg2$genre_id <- gsub(" ", "", as.character(gg2$genre_id))
genre_movies <- gg2[-1,]

write.csv(genre_movies, file = "C:/Users/Marielle/Downloads/the-movies-dataset/genre_movie.csv", row.names = FALSE)


#actor and movie_actor


id <- c(1)
name <- c(1)
df <-  data.frame(id,name)

movie_id <- c(1)
actor_id <- c(1)
df2 <-  data.frame(movie_id,actor_id)

for (j in 1:nrow(credits)) {
  
  string <- toString(credits$cast[j])
  string2 <-  strsplit(string, "[,:]+")
  
  if(length(string2[[1]]) >= 2) {
    
    for (i in seq(10, 80, by=16)) {
      
      df[nrow(df) + 1,] = c(string2[[1]][i],string2[[1]][i+2])
      
      df2[nrow(df) + 1,] = c(credits$id[j],string2[[1]][i])
      
    }
  }
}


gg2 <- df
gg2$id <- gsub(" ", "", as.character(gg2$id))
gg2$name <- gsub("]", "", as.character(gg2$name))
gg2$name <- gsub("'", "", as.character(gg2$name))
gg2$name <- gsub("\"", "", as.character(gg2$name))
actors_table <- gg2 %>% distinct(id,name)
actors_table$name <- substring(actors_table$name, 2)
actors_table <- actors_table[-1,]

test <- actors_table
test$id <- as.numeric(as.character(test$id))
test <- na.omit(test, test$id, invert=FALSE)

write.csv(test, file = "C:/Users/Marielle/Downloads/the-movies-dataset/actors.csv", row.names = FALSE)


gg2 <- df2
gg2$movie_id <- gsub(" ", "", as.character(gg2$movie_id))
gg2$actor_id <- gsub(" ", "", as.character(gg2$actor_id))

test <- gg2
test$movie_id <- as.numeric(as.character(test$movie_id))
test$actor_id <- as.numeric(as.character(test$actor_id))
test <- na.omit(test, test$id, invert=FALSE)
test <- test[-1,]

write.csv(test, file = "C:/Users/Marielle/Downloads/the-movies-dataset/movie_actor.csv", row.names = FALSE)

