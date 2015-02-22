#' Word cloud from a character vector
#'
#' Modified from: \url{https://sites.google.com/site/miningtwitter/questions/talking-about/wordclouds/wordcloud1}
#'
#' Stemming is applied. Stopwords are removed.
#' All words are converted to lowercase.
#' TF-IDF weighting is used.
#'
#' @param corpus character vector. Each element is the text from a document.
#' @param colors a vector of colors used when creating the word cloud
#' @return nothing. Simply plots word cloud. Can be captured via, say,
#' \code{\link{png}}.
word_cloud <- function(corpus, colors) {
  corpus_obj <- Corpus(VectorSource(corpus))

  # Document term matrix applying some transformations
  tdm <- TermDocumentMatrix(corpus_obj,
                            control = list(removePunctuation=TRUE,
                                           stopwords=stopwords("english"),
                                           removeNumbers=TRUE,
                                           tolower=TRUE,
                                           weighting=weightTfIdf
                                           ))

  # Word counts in decreasing order as a data frame.
  word_freqs <- sort(rowSums(as.matrix(tdm)), decreasing=TRUE)
  word_freqs <-  data.frame(word=names(word_freqs), freq=word_freqs)

  with(word_freqs, wordcloud(word, freq, random.order=FALSE, colors=colors))
}
