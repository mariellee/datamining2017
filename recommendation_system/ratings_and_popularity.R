meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")
imdb_data <- read.csv("c:/kool/andmekaeve/movies_project/Data/imdb/imdb_data.csv")

meta_data_limited <- meta_data %>% select(popularity, imdb_id, release_date, vote_average, vote_count)
imdb_data_limited <- imdb_data %>% select(-X)

#connecting data frames by imdb_id
data <- merge(meta_data_limited, imdb_data_limited, by="imdb_id")   

# Adding values that wasn't added after merging automatically (movies that were problematic in imdb site)
missing_from_data <- meta_data %>% filter(!metadata$imdb_id %in% data$imdb_id)
missing_from_data <- missing_from_data %>% select(popularity, imdb_id, release_date, vote_average, vote_count)

missing_from_data$rating = rep(NA, nrow(missing_from_data))
zero_column = rep(0, nrow(missing_from_data))
missing_from_data$rating_count = zero_column
missing_from_data$review_count = zero_column
missing_from_data$critics_count = zero_column

new_data <- rbind(data, missing_from_data)