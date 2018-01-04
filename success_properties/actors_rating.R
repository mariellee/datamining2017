# read actor data
actor <- read.csv("D:/Studium/Data mining/datamining2017/Data/movie set kaggle/actors_first_5.csv")
actor_movie <- read.csv("D:/Studium/Data mining/datamining2017/Data/movie set kaggle/movie_actor_first_5.csv")

#get mean rating actor
get_mean_rating_actor <- function(actor_ID) {
  
  movies <- actor_movie %>% filter(actor_id == actor_ID)
  ratings <- final_ratings %>% filter(movieId %in% movies$movie_id)
  mean_rating <- mean(ratings$Mean) * 2
  
  movies_imdb_id <- movie_data %>% filter(id %in% movies$movie_id)
  ratings_imdb <- imdb_data %>% filter(imdb_id %in% movies_imdb_id$imdb_id)
  mean_rating_imdb <- mean(ratings_imdb$rating)
  
  mean <- (mean_rating + mean_rating_imdb) / 2
  
  return(mean)
}

vector_mean_rating <-  c()

for (i in 1:nrow(actor)) {
  
  vector_mean_rating[i] <- get_mean_rating_actor(actor$id[i])
}

#add vector to dataframe
actor_mean_rating <- actor
actor_mean_rating$mean_rating <- vector_mean_rating

# elimnate all missing values
actor_mean_rating <- na.omit(actor_mean_rating)

# filter actors which appear in more than 10 movies
actors_more_than_10_movies <- actor_movie %>% count(actor_id) %>%filter(n > 10)

# get average mean actor value
mean_all_actor <- mean(actor_mean_rating$mean_rating)

# prepare plot data
df <- actor_mean_rating %>% filter(id %in% actors_more_than_10_movies$actor_id)
actor_mean_rating_top_5 <- head(df %>% arrange(desc(mean_rating)), 5)
actor_mean_rating_least_5 <- head(df %>% arrange(mean_rating), 5)
actor_plot <- rbind(actor_mean_rating_least_5, actor_mean_rating_top_5)
actor_plot <- actor_plot %>% arrange(desc(mean_rating))
actor_plot <- actor_plot %>% mutate(status = case_when(mean_rating >= mean_all_actor ~ "Top", mean_rating < mean_all_actor ~ "Flop"))

# plot actor of all movies 
ggplot(actor_plot)+geom_bar(aes(x=reorder(name,mean_rating),y=mean_rating,fill = factor(status)),stat="identity") +coord_flip() + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(0,mean_all,label = "*", vjust = -1))  + theme(axis.title.x=element_blank(),axis.title.y=element_blank(),legend.position="none") + ggtitle("All movies") 


# join actor with movie id
actor_mean_movie <- inner_join(actor_mean_rating, actor_movie, by=c("id"="actor_id"))

# cast release_date column as datetime datatype
movie_data$release_date <- as.Date(movie_data$release_date)
#filter movies which are older than 2008
movies_older_than_2008 <- movie_data %>% filter(release_date > "2008-01-01" & original_language == "en")

actor_mean_movie <- actor_mean_movie %>% filter(movie_id%in%movies_older_than_2008$id)
actor_mean_movie_2 <- actor_mean_movie %>% select(id,name, mean_rating)
actor_mean_movie_2 <- unique(actor_mean_movie_2)

df <- actor_mean_movie_2 %>% filter(id %in% actors_more_than_20_movies$actor_id & id != 12151)
actor_mean_rating_top_5 <- head(df %>% arrange(desc(mean_rating)), 5)
actor_mean_rating_least_5 <- head(df %>% arrange(mean_rating), 5)
actor_plot <- rbind(actor_mean_rating_least_5, actor_mean_rating_top_5)
actor_plot <- actor_plot %>% arrange(desc(mean_rating))
actor_plot <- actor_plot %>% mutate(status = case_when(mean_rating >= mean_all_actor ~ "Top", mean_rating < mean_all_actor ~ "Flop"))

# plot top actor since 2008
ggplot(actor_plot)+geom_bar(aes(x=reorder(name,mean_rating),y=mean_rating,fill = factor(status)),stat="identity") +coord_flip() + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(0,mean_all,label = "*", vjust = -1))  + theme(axis.title.x=element_blank(),axis.title.y=element_blank(),legend.position="none") + ggtitle("Last 10 years") 

# check Bill Clinton movies manually
rr <- actor_movie %>% filter(actor_id == 116341)
movie_data %>% filter (id %in% rr$movie_id) %>% select(title)
