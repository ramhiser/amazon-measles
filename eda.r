# Exploratory Data Analysis
library(ProjectTemplate)
load.project()

# Tally of Reviews
p <- amazon_reviews %>%
  group_by(num_stars) %>%
  tally() %>%
  ggplot(., aes(x=factor(num_stars), weight=n))
p <- p + geom_bar()
p <- p + xlab("Number of Stars") + ylab("Number of Reviews")
p <- p + ggtitle("Amazon Customer Reviews of Melanie's Marvelous Measles")
p
ggsave(p, file="customer-reviews.png")

# TODO:
# 1. Word cloud for 1-star and 5-star reviews
# 2. Munge data to feed into topic models
# 3. Generate new product reviews with Markov generator (both 1 and 5-star reviews)
# 4. Fit topic modls
