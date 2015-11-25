# Text Analytics
install.packages(c("openNLP", "openNLPdata", "tm", "NLP", "openNLPmodels.en"))
library(openNLP)
library(openNLPdata)
library(tm)
library(NLP)
library(openNLPmodels.en)


s <- paste(c("Pierre Vinken. 61 years old, will join the board as",
           "nonexecutive director on November 29. ",
           "Mr. Vinken is chairman of Chicago , ",
           "the Dutch publishing group."), 
           collapse = "")

s <- as.String(s)
sent_token_annotator <- Maxent_Sent_Token_Annotator()
a1 <- annotate(s, sent_token_annotator)
