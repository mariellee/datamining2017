imdb1 <- read.csv("c:/kool/andmekaeve/movies_project/Data/imdb/imdb_data1.csv")
imdb2 <- read.csv("c:/kool/andmekaeve/movies_project/Data/imdb/idmb_data2.csv")
imdb3 <- read.csv("c:/kool/andmekaeve/movies_project/Data/imdb/imdb_data3.csv")

library(dplyr)

data <- rbind(imdb1, imdb2, imdb3)
important_data <- data %>% filter(!is.na(rating))
important_data <- important_data %>% filter(imdb_id != 0)

important_data$critics_count[is.na(important_data$critics_count)] = 0
important_data$review_count[is.na(important_data$review_count)] = 0

important_data <- important_data %>% select(-X)
important_data <- important_data[!duplicated(important_data),]

temp <-  important_data %>% filter(imdb_id == "tt0127834")
temp <- temp %>% arrange(rating_count)
row_to_add <- temp[1,]
important_data <- important_data %>% filter(imdb_id != "tt0127834")
important_data <- rbind(important_data, row_to_add)

temp <-  important_data %>% filter(imdb_id == "tt0235679")
temp <- temp %>% arrange(rating_count)
row_to_add <- temp[1,]
important_data <- important_data %>% filter(imdb_id != "tt0235679")
important_data <- rbind(important_data, row_to_add)

temp <-  important_data %>% filter(imdb_id == "tt0287635")
temp <- temp %>% arrange(rating_count)
row_to_add <- temp[1,]
important_data <- important_data %>% filter(imdb_id != "tt0287635")
important_data <- rbind(important_data, row_to_add)
  
temp <-  important_data %>% filter(imdb_id == "tt0499537")
temp <- temp %>% arrange(rating_count)
row_to_add <- temp[1,]
important_data <- important_data %>% filter(imdb_id != "tt0499537")
important_data <- rbind(important_data, row_to_add)

temp <-  important_data %>% filter(imdb_id == "tt0067306")
temp <- temp %>% arrange(rating_count)
row_to_add <- temp[1,]
important_data <- important_data %>% filter(imdb_id != "tt0067306")
important_data <- rbind(important_data, row_to_add)

temp <-  important_data %>% filter(imdb_id == "tt2121382")
temp <- temp %>% arrange(rating_count)
row_to_add <- temp[1,]
important_data <- important_data %>% filter(imdb_id != "tt2121382")
important_data <- rbind(important_data, row_to_add)

head(sort(table(important_data$imdb_id),decreasing=T), 15)


write.csv(important_data, file="c:/kool/andmekaeve/movies_project/Data/imdb/imdb_data.csv")

