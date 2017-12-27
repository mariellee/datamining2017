meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")

data <- meta_data %>% filter(popularity != "Beware Of Frost Bites")   #removed a useless line
data <- data %>% select(-X)

data <- data %>% filter(imdb_id != "")
data <- data %>% filter(imdb_id != 0)

# removing duplicated lines
data <- data[!duplicated(data),]

# Changing duplicated lines, where only popularity is different
temp <- data %>% filter(imdb_id == "tt0022879")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0022879")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt0046468")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0046468")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt0082992")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0082992")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt0100361")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0100361")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt0157472")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0157472")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt0235679")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0235679")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt0270288")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0270288")
data <- rbind(data, row_to_add)


temp <- data %>% filter(imdb_id == "tt0287635")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0287635")
data <- rbind(data, row_to_add)


temp <- data %>% filter(imdb_id == "tt0454792")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0454792")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt0499537")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt0499537")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt1701210")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt1701210")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt1736049")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt1736049")
data <- rbind(data, row_to_add)

temp <- data %>% filter(imdb_id == "tt2018086")
popularity <- mean(temp$popularity)
row_to_add <- temp[1,]
row_to_add$popularity <- popularity
data <- data %>% filter(imdb_id != "tt2018086")
data <- rbind(data, row_to_add)


head(sort(table(data$imdb_id),decreasing=T), 15)


write.csv(data, file="C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
