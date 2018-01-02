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

actor_mean_rating <- na.omit(actor_mean_rating)

list_of_top_20_actors <- c("Jack Nicholson", "Marlon Brando", "Robert De Niro", "Al Pacino", "Daniel Day-Lewis", "Dustin Hoffman", "Tom Hanks", "Anthony Hopkins", "Paul Newman", "Denzel Washington", "Spencer Tracy", "Laurence Olivier", "Jack Lemmon", "Michael Caine", "James Stewart", "Robin Williams", "Robert Duvall", "Sean Penn", "Morgan Freeman", "Jeff Bridges")
list_of_top_20_actress <- c("Julia Roberts", "Katherine Hepburn", "Jessica Lange", "Meryl Streep", "Elizabeth Taylor", "Cate Blanchett", "Bette Davis", "Glenn Close", "Emma Thompson", "Vivien Leigh", "Jodie Foster", "Sigourney Weaver", "Shirley MacLaine", "Jane Fonda", "Judi Dench", "Michelle Pfeiffer", "Kate Winslet", "Gena Rowlands", "Maggie Smith", "Julianne Moore")

ff <- actor_mean_rating %>% filter(name %in% list_of_top_20_actors | name %in% list_of_top_20_actress)

actors_more_than_5_movies <- actor_movie %>% count(actor_id) %>%filter(n > 5)

mean_all_actor <- mean(actor_mean_rating$mean_rating)

df <- actor_mean_rating %>% filter(id %in% actors_more_than_5_movies$actor_id)
actor_mean_rating_top_5 <- head(df %>% arrange(desc(mean_rating)), 5)
actor_mean_rating_least_5 <- head(df %>% arrange(mean_rating), 5)
actor_plot <- rbind(actor_mean_rating_least_5, actor_mean_rating_top_5)
actor_plot <- actor_plot %>% arrange(desc(mean_rating))
actor_plot <- actor_plot %>% mutate(status = case_when(mean_rating >= mean_all_actor ~ "Top", mean_rating < mean_all_actor ~ "Flop"))



ggplot(actor_plot)+geom_bar(aes(x=reorder(name,mean_rating),y=mean_rating,fill = factor(status)),stat="identity") +coord_flip() + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(0,mean_all,label = "mean ranking", vjust = -1))
