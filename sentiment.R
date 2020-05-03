
# install.packages('syuzhet', repos = "http://cran.us.r-project.org")
# install.packages('lubridate', repos = "http://cran.us.r-project.org")
# install.packages('ggplot2', repos = "http://cran.us.r-project.org")
# install.packages('scales', repos = "http://cran.us.r-project.org")
# install.packages('reshape2', repos = "http://cran.us.r-project.org")
# install.packages('dplyr', repos = "http://cran.us.r-project.org")
# install.packages('tidytext', repos = "http://cran.us.r-project.org")
# install.packages("readr", repos = "http://cran.us.r-project.org")
# install.packages("SnowballC", repos = "http://cran.us.r-project.org")
# install.packages("textstem", repos = "http://cran.us.r-project.org")
# install.packages("tidyverse", repos = "http://cran.us.r-project.org")
# install.packages("tm", version = "0.7-1", repos = "http://cran.us.r-project.org")
# install.packages("AFINN-111", repos = "http://cran.us.r-project.org")
# install.packages("textdata", repos = "http://cran.us.r-project.org")



library(dplyr)
library(readr)
library(tidytext)
library(SnowballC)
library(textstem)
library(tidyverse)
library(tm)
library(textdata)

#Pull the file 
tweets <- read.csv('apple.csv')
corpus <- iconv(tweets$text, to = "utf-8-mac")
text_lines <- Corpus(VectorSource(corpus))

# Convert to lowercase 
text_lines <- tm_map(text_lines, tolower)
# remove punctuation
text_lines <- tm_map(text_lines, removePunctuation)
# remove remove numbers
text_lines <- tm_map(text_lines, removeNumbers)
# remove stop words
text_lines <- tm_map(text_lines, removeWords, stopwords('english'))
# remove url
removeURL <- function(x) gsub('http[[:alnum:]]*', '', x)
text_lines <- tm_map(text_lines, content_transformer(removeURL))
# convert albertan to alberta 
text_lines <- tm_map(text_lines, removeWords, c('albertan', 'alberta'))
# strip extra spaces
text_lines <- tm_map(text_lines, stripWhitespace)

# Convert to tibble? 
text_lines <- tibble(text = corpus)

# Convert to single words column
single_words <- unnest_tokens(text_lines, word, text)

result <- single_words %>%
  inner_join(get_sentiments("afinn"))


print(result)


#stemm
# stemmed <- single_words %>%
#   mutate(word_stem = SnowballC::wordStem(word)) 


# stemmed_words <- stemmed[,2]

