movie_data <-  read.csv("C:/Users/Marielle/Downloads/the-movies-dataset/movies_metadata.csv")
movie_rating <- read.csv("C:/Users/Marielle/Downloads/the-movies-dataset/ratings.csv")
imdb_data <-  read.csv("C:/Users/Marielle/Documents/datamining2017/Data/imdb/imdb_data.csv")

#get highest ranking movie
top_1000_imdb <- head((imdb_data %>% arrange(desc(rating))),1000)

#get movie titles
movies_1000_imdb <- inner_join(top_1000_imdb, movie_data, by= c("imdb_id" = "imdb_id"))


#calculate mean rating for each movie out of single user votes
mean_rating <- movie_rating %>% group_by(movieId) %>% summarize(Mean = mean(rating))

#eliminate all movies which have just a few ratings
count_rating <- movie_rating %>% count(movieId) 
ratings_count_higher_1000 <- count_rating %>% filter(n < 1000)
final_ratings <- anti_join(mean_rating, ratings_count_higher_1000, by = "movieId")

#ratings sorted by mean ratings
final_ratings <- final_ratings %>% arrange(desc(Mean))


# get mean rating out of all movies of single tag 
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

# test
get_mean_rating_tag(9826)

#calculate all mean ratings for single tags using function above 
vector_mean_rating <-  c()

for (i in 1:nrow(tags)) {
  
  vector_mean_rating[i] <- get_mean_rating_tag(tags$ids[i])
}


#add vector to dataframe
tags_mean_rating <- tags
tags_mean_rating$mean_rating <- vector_mean_rating

#get top 5 and least 5 keywords by sorting the mean ratings
tags_mean_rating_top_5 <- head(tags_mean_rating %>% arrange(desc(mean_rating)), 5)
tags_mean_rating_least_5 <- head(tags_mean_rating %>% arrange(mean_rating), 5)

#create data frame for plotting by binding top and least keywords
tags_plot <-  rbind(tags_mean_rating_least_5, tags_mean_rating_top_5)
tags_plot <- tags_plot %>% arrange(desc(mean_rating))

ggplot(tags_plot, aes(x=names))+geom_bar(aes(y=mean_rating),stat="identity")

#get keywords wich occur in more than 50 movies to get more evaluable result
keywords_more_than_50_movies <- tags_movie %>% count(id_keyword) %>%filter(n > 50)

# remove alle NA values from data frame to calculate mean rating of all keywords
tags_mean_rating <- na.omit(tags_mean_rating )
mean_all <- mean(tags_mean_rating$mean_rating)

# filter just keywords which occur in more than 50 movies
df <- tags_mean_rating %>% filter(ids %in% keywords_more_than_50_movies$id_keyword)
tags_mean_rating_top_5 <- head(df %>% arrange(desc(mean_rating)), 5)
tags_mean_rating_least_5 <- head(df %>% arrange(mean_rating), 5)
tags_plot <-  rbind(tags_mean_rating_least_5, tags_mean_rating_top_5)
tags_plot <- tags_plot %>% arrange(desc(mean_rating))

# add column which determine if keyword is "Flop" or "Top" depending on if it is higher or lower than mean rating
tags_plot <- tags_plot %>% mutate(status = case_when(mean_rating >= mean_all ~ "Top", mean_rating < mean_all ~ "Flop"))

plot_tag <- ggplot(tags_plot)+geom_bar(aes(x=reorder(names,mean_rating),y=mean_rating,fill = factor(status)),stat="identity") +coord_flip() + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(0,mean_all,label = "*", vjust = -1)) + ggtitle("Keywords (> 50 movies)") + guides(fill=guide_legend(title=NULL))
plot_tag + theme(axis.title.x=element_blank(),axis.title.y=element_blank(),legend.position="none") 


# which relationships are the most interesting ones
relationships <- df %>% filter(grepl('relation',names))
relationships <- relationships %>% mutate(status = case_when(mean_rating >= mean_all ~ "Top", mean_rating < mean_all ~ "Flop"))
plot_rel <- ggplot(relationships)+geom_bar(aes(x=reorder(names,mean_rating),y=mean_rating,fill = factor(status)),stat="identity") +coord_flip() + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(0,mean_all,label = "*", vjust = -1)) + ggtitle("Relationships") + guides(fill=guide_legend(title=NULL))
plot_rel + theme(axis.title.x=element_blank(),axis.title.y=element_blank(),legend.position="none") 

# which animals are the most interesting ones
animals <- df %>% filter(grepl('horse|cat|dog|whale|shark|bird|snake|bear',names))
animals <- subset(animals, names %in% c(" cat"," dog"," horse"," shark"))
animals <- animals %>% mutate(status = case_when(mean_rating >= mean_all ~ "Top", mean_rating < mean_all ~ "Flop"))
plot_an <- ggplot(animals)+geom_bar(aes(x=reorder(names,mean_rating),y=mean_rating,fill = factor(status)),stat="identity") +coord_flip() + labs(y='Mean rating (out of 2 ranking systems)',x='Tags (> 50 movies)') + geom_hline(yintercept = mean_all) + geom_text(aes(0,mean_all,label = "*", vjust = -1)) +ggtitle("Animals") + guides(fill=guide_legend(title=NULL))
plot_an + theme(axis.title.x=element_blank(),axis.title.y=element_blank(),legend.position="none") 
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





