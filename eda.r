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

# Word clouds for 1-star and 5-star reviews
png("review-word-cloud.png", width=7.9, height=6.39, units="in", res=300)
word_cloud(amazon_reviews$review, colors=brewer.pal(8, "Dark2"))
dev.off()

png("negative-review-word-cloud.png", width=7.9, height=6.39, units="in", res=300)
negative_reviews <- amazon_reviews %>% filter(num_stars <= 2)
word_cloud(negative_reviews$review, colors=brewer.pal(8, "Dark2"))
dev.off()

png("positive-review-word-cloud.png", width=7.9, height=6.39, units="in", res=300)
positive_reviews <- amazon_reviews %>% filter(num_stars > 2)
word_cloud(positive_reviews$review, colors=brewer.pal(8, "Dark2"))
dev.off()

# Comparison word cloud
all_reviews <- c(paste(negative_reviews$review, collapse=" "),
                 paste(positive_reviews$review, collapse=" "))
all_corpus <- Corpus(VectorSource(all_reviews))
all_corpus <- tm_map(all_corpus, removePunctuation)
all_corpus <- tm_map(all_corpus, content_transformer(tolower))
all_corpus <- tm_map(all_corpus, removeNumbers)
all_corpus <- tm_map(all_corpus, function(x) removeWords(x, stopwords("english")))

tdm <- TermDocumentMatrix(all_corpus)
colnames(tdm) <- c("Pro-Vaxxers", "Anti-Vaxxers")

png("comparison-word-cloud.png", width=7.9, height=6.39, units="in", res=300)
comparison.cloud(as.matrix(tdm),
                 random.order=FALSE,
                 colors=c("#00B2FF", "red"),
                 title.size=1.5,
                 max.words=500)
dev.off()
