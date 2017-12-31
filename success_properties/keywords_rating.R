movie_data <-  read.csv("D:/Studium/Data mining/the-movies-dataset/ratings.csv")
movie_rating <- read.csv("D:/Studium/Data mining/the-movies-dataset/ratings.csv")

imdb_data <-  read.csv("D:/Studium/Data mining/datamining2017/Data/imdb/imdb_data.csv")

#get highest ranking movie
top_1000_imdb <- head((imdb_data %>% arrange(desc(rating))),1000)

#get movie titles
movies_1000_imdb <- inner_join(top_1000_imdb, movie_data, by= c("imdb_id" = "imdb_id"))


#calculate mean rating for each movie
mean_rating <- movie_rating %>% group_by(movieId) %>% summarize(Mean = mean(rating))

#eliminate all movies which have just a few ratings
count_rating <- movie_rating %>% count(movieId) 
ratings_count_higher_100 <- count_rating %>% filter(n < 1000)
final_ratings <- anti_join(mean_rating, ratings_count_higher_100, by = "movieId")

#Get highest rankings
final_ratings <- final_ratings %>% arrange(desc(Mean))


# get mean rating for a keyword 
get_mean_rating_tag <- function(tag_id) {
  
  movies <- tags_movie %>% filter(id_keyword == tag_id)
  ratings <- final_ratings %>% filter(movieId %in% movies$id_movie)
  mean_rating <- mean(ratings$Mean) * 2
  
  movies_imdb_id <- movie_data %>% filter(id %in% movies$id_movie)
  ratings_imdb <- imdb_data %>% filter(imdb_id %in% movies_imdb_id$imdb_id)
  mean_rating_imdb <- mean(ratings_imdb$rating)
  
  mean <- (mean_rating + mean_rating_imdb) / 2
  
  return(mean)
}

get_mean_rating_tag(9826)


vector_mean_rating <-  c()

for (i in 1:nrow(tags)) {
  
  vector_mean_rating[i] <- get_mean_rating_tag(tags$ids[i])
}


#add vector to dataframe
tags_mean_rating <- tags
tags_mean_rating$mean_rating <- vector_mean_rating

tags_mean_rating_top_5 <- head(tags_mean_rating %>% arrange(desc(mean_rating)), 5)
tags_mean_rating_least_5 <- head(tags_mean_rating %>% arrange(mean_rating), 5)

tags_plot <-  rbind(tags_mean_rating_least_5, tags_mean_rating_top_5)
tags_plot <- tags_plot %>% arrange(desc(mean_rating))

ggplot(tags_plot, aes(x=names))+geom_bar(aes(y=mean_rating),stat="identity")

keywords_more_than_50_movies <- tags_movie %>% count(id_keyword) %>%filter(n > 50)

tags_mean_rating <- na.omit(tags_mean_rating )
mean_all <- mean(tags_mean_rating$mean_rating)

df <- tags_mean_rating %>% filter(ids %in% keywords_more_than_50_movies$id_keyword)
tags_mean_rating_top_5 <- head(df %>% arrange(desc(mean_rating)), 5)
tags_mean_rating_least_5 <- head(df %>% arrange(mean_rating), 5)
tags_plot <-  rbind(tags_mean_rating_least_5, tags_mean_rating_top_5)
tags_plot <- tags_plot %>% arrange(desc(mean_rating))
tags_plot <- tags_plot %>% mutate(status = case_when(mean_rating >= 6 ~ "Top", mean_rating < 6 ~ "Flop"))



ggplot(tags_plot)+geom_bar(aes(x=reorder(names,mean_rating),y=mean_rating,fill = factor(status)),stat="identity") +coord_flip() + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(0,mean_all,label = "mean ranking", vjust = -1))



# which relationships are the most interesting ones
relationships <- df %>% filter(grepl('relation',names))
relationships <- relationships %>% mutate(status = case_when(mean_rating >= mean_all ~ "Top", mean_rating < mean_all ~ "Flop"))
ggplot(relationships)+geom_bar(aes(x=reorder(names,mean_rating),y=mean_rating,fill = factor(status)),stat="identity") +coord_flip() + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(0,mean_all,label = "mean ranking", vjust = -1))

# which animals are the most interesting ones
animals <- df %>% filter(grepl('horse|cat|dog|whale|shark|bird|snake|bear',names))
animals <- subset(animals, names %in% c(" cat"," dog"," horse"," shark"))
animals <- animals %>% mutate(status = case_when(mean_rating >= mean_all ~ "Top", mean_rating < mean_all ~ "Flop"))
ggplot(animals)+geom_bar(aes(x=reorder(names,mean_rating),y=mean_rating,fill = factor(status)),stat="identity") +coord_flip() + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(0,mean_all,label = "mean ranking", vjust = -1))

# female vs. male
gender <- df %>% filter(grepl('male|king|queen|princess|prince|man|lesb|men|director|actor|actress|gay',names))
gender <- subset(gender, ids %in% c(5248,13084,293,10768,2011,3230,255,33458))
gender_vector <- c("female","male","female","female","female","male","male","male")
gender$gender <- gender_vector

king_queen <- gender %>% filter(grepl('king|queen',names))
ggplot(king_queen)+geom_bar(aes(x=reorder(names,mean_rating),y=mean_rating,fill = factor(gender)),stat="identity") + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(1,mean_all,label = "mean rating", vjust = -1))

friendship <- gender %>% filter(grepl('friendship',names))
ggplot(friendship)+geom_bar(aes(x=reorder(names,mean_rating),y=mean_rating,fill = factor(gender)),stat="identity") + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(1,mean_all,label = "mean rating", vjust = -1))

homo <- gender %>% filter(grepl('lesbian|gay',names))
ggplot(homo)+geom_bar(aes(x=reorder(names,mean_rating),y=mean_rating,fill = factor(gender)),stat="identity") + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(1,mean_all,label = "mean rating", vjust = -1))

#pie chart
tags_mean_rating_top_10 <- head(df %>% arrange(desc(mean_rating)), 10)
sum_mean <- sum(tags_mean_rating_top_10$mean_rating)
tags_mean_rating_top_10 <- tags_mean_rating_top_10 %>% mutate(relative = mean_rating/sum_mean)

ggplot(tags_mean_rating_top_10, aes(x="", y=relative, fill=names))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + theme_minimal()





