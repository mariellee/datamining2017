movie_data <-  read.csv("C:/Users/Marielle/Downloads/the-movies-dataset/movies_metadata.csv")
genre <- read.csv("C:/Users/Marielle/Documents/datamining2017/Data/movie set kaggle/genres.csv")
genre_movie <- read.csv("C:/Users/Marielle/Documents/datamining2017/Data/movie set kaggle/genre_movie.csv")


# filte all movies with higher vote_average than 0
movie_df <- movie_data %>% filter(vote_average > 0)

# join movie_df datagrame with genres 
movie_df$id <- as.numeric(movie_df$id)
genre_movie_df <- inner_join(genre_movie, movie_df, by = c("movie_id"="id"))
genre_movie_df <- genre_movie_df %>% select(movie_id, genre_id, budget, vote_average, runtime, vote_count)

ggplot(genre_movie_df) + geom_point(aes(x=runtime,y=vote_average, color=as.factor(genre_id)), stat="identity")

# get mean ratings for each movie using ID
get_mean_rating_movie <- function(movie_ID) {
  
  ratings <- final_ratings %>% filter(movieId == movie_ID)
  mean_rating <- mean(ratings$Mean) * 2
  
  movies_imdb_id <- movie_data %>% filter(id == movie_ID)
  ratings_imdb <- imdb_data %>% filter(imdb_id %in% movies_imdb_id$imdb_id)
  mean_rating_imdb <- mean(ratings_imdb$rating)
  
  mean <- (mean_rating + mean_rating_imdb) / 2
  
  return(mean)
}

# create vector with mean ratings 
vector_mean_rating_movie <-  c()

for (i in 1:nrow(genre_movie_df)) {
  
  vector_mean_rating_movie[i] <- get_mean_rating_movie(genre_movie_df$movie_id[i])
}

# add vector to genre movie table
genre_movie_df$vote_all <- vector_mean_rating_movie


genre_movie_df$genre_id <- as.factor(genre_movie_df$genre_id)
genre$id <- as.factor(genre$id)
genre_movie_2 <- left_join(genre_movie_df, genre, by= c("genre_id"="id"))

# filter vote count which are higher than 1000
genre_movie_2 <- genre_movie_2 %>% filter(vote_count > 1000)

# plot genres regarding average voting using boxplot
ggplot(genre_movie_2, aes(x=name, y=vote_average,fill=name)) + geom_boxplot() + labs(title = "Genres and average vote", x = "Genre", y="Average rating (> 1000 votes)") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
