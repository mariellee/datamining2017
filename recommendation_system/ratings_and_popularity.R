meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
imdb_data <- read.csv("c:/kool/andmekaeve/movies_project/Data/imdb/imdb_data.csv")

library(dplyr)

meta_data_limited <- meta_data %>% select(popularity, imdb_id, release_date, vote_average, vote_count, original_title)
imdb_data_limited <- imdb_data %>% select(-X)

#connecting data frames by imdb_id
data <- merge(meta_data_limited, imdb_data_limited, by="imdb_id")   

# Adding values that wasn't added after merging automatically (movies that were problematic in imdb site)
missing_from_data <- meta_data %>% filter(!meta_data$imdb_id %in% data$imdb_id)
missing_from_data <- missing_from_data %>% select(popularity, imdb_id, release_date, vote_average, vote_count, original_title)

missing_from_data$rating = rep(NA, nrow(missing_from_data))
zero_column = rep(0, nrow(missing_from_data))
missing_from_data$rating_count = zero_column
missing_from_data$review_count = zero_column
missing_from_data$critics_count = zero_column

data <- rbind(data, missing_from_data)

#Creating modified table with rating count and average rating and prediction score
#popularity, rating, vote_count, review_count and critics_cound influences the result.
#total prediction score is between 0-10

#popularity gives maximally 3 points
# formula: points = 3 * (1-(1 / sqrt(1 + popularity))) + 0.1  (maximum close to 3 points)

#rating gives maximally 4 points
#formula: if rating < 3 then 0 else 4 * ((rating - 3) / 6.6)

#vote_count gives maximally 1.5 points
#formula: 1.5 * (rating_count^(1/7)/7.885)

#review_count gives maximally 0.75 points
#formula: 0.75 * sqrt(review_count /8) /25.252  

#critics_count gives maximally 0.75 points
#formula: 0.75 * sqrt(critics_count) /29.09

df <- data.frame(matrix(ncol = 9, nrow = 0))
names <- c("imdb_id", "release_date", "original_title", "popularity", "rating", "vote_count", "revew_count", 
           "critics_count", "prediction_score")
colnames(df) <- names

for (i in c(1:nrow(data))) {
  score <-  0                     
  rating_count <-  data[i,5] + data[i,8]
  rating_sum <-  data[i,4] * data[i,5] + data[i, 7] * data[i, 8]
  if (is.na(rating_count) || rating_count == 0 )
    average <- 0
  else
    average <- round(rating_sum/rating_count, 2)
  
  score <- score + 3 * (1 - (1 / sqrt(1 + data[i,2]))) + 0.1        # Adding popularity score
  if (as.numeric(average) > 3)                                      # Adding rating score
    score <- score + 4 * ((average - 3) / 6.6)
  score <- score + 1.5 * (rating_count^(1/7)/7.885)                 #Adding rating count score
  score <-  score + 0.75 * sqrt(data[i,9] /8) /25.252               #Adding review count score
  score <- score + 0.75 * sqrt(data[i,10]) / 29.09                  #Adding critics count score
  
  row <- c(as.character(data[i,1]), as.character(data[i,3]), as.character(data[i,6]), 
           data[i,2], average, rating_count, data[i,9], data[i,10], score)
  df[nrow(df) + 1,] <- row
}

df$popularity <- as.numeric(as.character(df$popularity))
#df$rating <- as.numeric(as.character(df$revew_count))
df$vote_count <- as.numeric(as.character(df$vote_count))
df$revew_count <- as.numeric(as.character(df$revew_count))
df$critics_count <- as.numeric(as.character(df$critics_count))
df$prediction_score <- as.numeric(as.character(df$prediction_score))

write.csv(df, file="C:/kool/andmekaeve/movies_project/recommendation_system/metascores.csv")
rm(list=ls()) #clearing memory

