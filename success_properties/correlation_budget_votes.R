# this first part of the script is not used for the poster
# because I could not find any correlation between budget/average voting and runtime/average voting


# correlations budget, vote_average

movie_data$budget <- as.numeric(movie_data$budget)

ggplot(movie_data, aes(x=budget,y=vote_average)) + geom_point(stat="identity")

#create new table out of genres and movies 

#get genre data
genre <- read.csv("C:/Users/Marielle/Documents/datamining2017/Data/movie set kaggle/genres.csv")
genre_movie <- read.csv("C:/Users/Marielle/Documents/datamining2017/Data/movie set kaggle/genre_movie.csv")

movie_df <- movie_data %>% filter(vote_average > 0 & budget > 10)

ggplot(movie_df, aes(x=budget,y=vote_average)) + geom_point(stat="identity")

# correlation regarding genre 
movie_df$id <- as.numeric(movie_df$id)
genre_movie_df <- inner_join(genre_movie, movie_df, by = c("movie_id"="id"))
genre_movie_df <- genre_movie_df %>% select(movie_id, genre_id, budget, vote_average, runtime)

ggplot(genre_movie_df) + geom_point(aes(x=budget,y=vote_average, color=as.factor(genre_id)), stat="identity")

# test one genre
sci_fi <- genre_movie_df %>% filter(genre_id==10752)
ggplot(sci_fi, aes(x=budget,y=vote_average)) + geom_point(stat="identity")


get_mean_rating_movie <- function(movie_ID) {
  
  ratings <- final_ratings %>% filter(movieId == movie_ID)
  mean_rating <- mean(ratings$Mean) * 2
  
  movies_imdb_id <- movie_data %>% filter(id == movie_ID)
  ratings_imdb <- imdb_data %>% filter(imdb_id %in% movies_imdb_id$imdb_id)
  mean_rating_imdb <- mean(ratings_imdb$rating)
  
  mean <- (mean_rating + mean_rating_imdb) / 2
  
  return(mean)
}


vector_mean_rating_movie <-  c()

for (i in 1:nrow(genre_movie_df)) {
  
  vector_mean_rating_movie[i] <- get_mean_rating_movie(genre_movie_df$movie_id[i])
}

genre_movie_df$vote_all <- vector_mean_rating_movie

ggplot(genre_movie_df) + geom_point(aes(x=runtime,y=vote_all, color=as.factor(genre_id)), stat="identity")

sci_fi <- genre_movie_df_wna %>% filter(genre_id==37)
ggplot(sci_fi, aes(x=budget,y=vote_all)) + geom_point(stat="identity")

genre_movie_df_wna <- na.omit(genre_movie_df)

cor(sci_fi$budget, sci_fi$vote_average)

cor_vec <- c()

for (i in 1:nrow(genre)) {
  
  f <- genre_movie_df %>% filter(genre_id==genre$id[i])
  cor_vec[i] <- cor(f$runtime, f$vote_average)
  
}

genre_cor <- genre
genre_cor$cor <- cor_vec


# correlation runtime
movie_run <- movie_data %>% filter(runtime > 0 & vote_average > 0 & runtime < 400)
genre_movie_run <- inner_join(genre_movie, movie_run, by = c("movie_id"="id"))
genre_movie_run <- genre_movie_run %>% select(movie_id, genre_id, vote_average, runtime)

cor(genre_movie_run$runtime,genre_movie_run$vote_average)

cor_vec_run <- c()

for (i in 1:nrow(genre)) {
  
  f <- genre_movie_run %>% filter(genre_id==genre$id[i])
  cor_vec_run[i] <- cor(f$runtime, f$vote_average)
  
}

genre_cor_run <- genre
genre_cor_run$cor <- cor_vec_run

f <- genre_movie_run %>% filter(genre_id==14)
ggplot(f) + geom_point(aes(x=runtime,y=vote_average), stat="identity")

 


vec_genre_id <- c(16, 35, 14, 28, 80, 27, 878)
genre_movie_2 <- genre_movie_df %>% filter(genre_id %in% vec_genre_id)
genre_movie_df$genre_id <- as.factor(genre_movie_df$genre_id)
genre$id <- as.factor(genre$id)
genre_movie_2 <- left_join(genre_movie_df, genre, by= c("genre_id"="id"))

ggplot(genre_movie_2, aes(x=name, y=vote_average,fill=name)) + geom_boxplot() + labs(title = "Genres and average vote", x = "Genre", y="Average rating") + theme(axis.text.x = element_text(angle = 90, hjust = 1))

genres_movie_2 %>% count()







################ 2ND PART
movie_df <- movie_data %>% filter(vote_average > 0)

# correlation regarding genre 
movie_df$id <- as.numeric(movie_df$id)
genre_movie_df <- inner_join(genre_movie, movie_df, by = c("movie_id"="id"))
genre_movie_df <- genre_movie_df %>% select(movie_id, genre_id, budget, vote_average, runtime, vote_count)

ggplot(genre_movie_df) + geom_point(aes(x=runtime,y=vote_average, color=as.factor(genre_id)), stat="identity")

#### TODO
vector_mean_rating_movie <-  c()

for (i in 1:nrow(genre_movie_df)) {
  
  vector_mean_rating_movie[i] <- get_mean_rating_movie(genre_movie_df$movie_id[i])
}

genre_movie_df$vote_all <- vector_mean_rating_movie


genre_movie_df$genre_id <- as.factor(genre_movie_df$genre_id)
genre$id <- as.factor(genre$id)
genre_movie_2 <- left_join(genre_movie_df, genre, by= c("genre_id"="id"))
genre_movie_2 <- genre_movie_2 %>% filter(vote_count > 1000)

ggplot(genre_movie_2, aes(x=name, y=vote_average,fill=name)) + geom_boxplot() + labs(title = "Genres and average vote", x = "Genre", y="Average rating (> 1000 votes)") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
