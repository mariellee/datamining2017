meta_data <- read.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")

View(meta_data)

data <- meta_data %>% filter(popularity != "Beware Of Frost Bites")   #removed a useless line

write.csv("C:/kool/andmekaeve/project/the-movies-dataset/movies_metadata.csv")