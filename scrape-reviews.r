library(ProjectTemplate)
load.project()

product_url <- 'http://www.amazon.com/Melanies-Marvelous-Measles-Stephanie-Messenger/dp/1466938897'
review_root <- 'http://www.amazon.com/Melanies-Marvelous-Measles-Stephanie-Messenger/product-reviews/1466938897/'
melanie_measles <- html(product_url)

# Number of Amazon reviews
num_reviews <- melanie_measles %>%
  html_node("#acrCustomerReviewText , #revF span") %>%
  html_text() %>%
  gsub(',| customer reviews$', '', .) %>%
  as.integer

# Iterator to traverse through each page of 10 product reviews.
iter_seq <- itertools2::iseq_len(ceiling(num_reviews / 10))

# TODO: Update to iterate through `iter_seq`
i <- 1
review_url <- paste0(review_root, "?pageNumber=", i)
review_page <- html(review_url)

review_text <- review_page %>%
  html_nodes('.reviewText') %>%
  html_text()

review_titles <- review_page %>%
  html_nodes(xpath='//*[@id="productReviews"]//tr/td[1]/div/div[2]/span[2]/b') %>%
  html_text()

review_dates <- review_page %>%
  html_nodes(xpath='//*[@id="productReviews"]//tr/td[1]/div/div[2]/span[2]/nobr') %>%
  html_text() %>%
  lubridate::mdy(.)

# Ex: 4,946 of 5,073 people found the following review helpful
found_helpful <- review_page %>%
  html_nodes(xpath='//*[@id="productReviews"]//tr/td[1]/div/div[1]') %>%
  html_text() %>%
  str_replace_all(., pattern=',', replace='') %>%
  str_extract_all(., pattern='[0-9]+')
num_helpful <- as.integer(sapply(found_helpful, "[[", 1))
num_considered <- as.integer(sapply(found_helpful, "[[", 2))

num_stars <- review_page %>%
  html_nodes(xpath='//*[@id="productReviews"]//tr/td[1]/div/div[2]/span[1]/span/span') %>%
  html_text() %>%
  str_replace(., ' out of 5 stars', '') %>%
  as.numeric

product_reviews <- mapply(list,
                          review_titles, review_text, num_stars, num_helpful, num_considered,
                          USE.NAMES=FALSE, SIMPLIFY=FALSE)

product_reviews <- do.call(rbind.data.frame, product_reviews)
colnames(product_reviews) <- c("title", "review", "num_stars", "num_helpful", "num_considered")

# Not added in mapply/do.call because R converts to numeric. (sadpanda)
product_reviews$date <- review_dates

# TODO:
# 1. Extract reviews, stars, helpful, and review date as a list (1431 elements) of named lists
# 2. Munge data to feed into topic models
# 3. Generate new product reviews with Markov generator (both 1 and 5-star reviews)
# 4. Fit topic modls
