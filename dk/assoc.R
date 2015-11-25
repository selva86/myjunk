# arules

library(arules)
data("Groceries")
inspect(head(Groceries))
rules_2 <- apriori(Groceries)

# trans2 <- read.transactions("AU_purchase_categories.txt", sep="\t",rm.duplicates=T)
# rules_2 <- apriori(trans2,parameter = list(supp = 0.000075,conf=0.3,minlen=3,maxlen=3) )
# rules_df2 <- as(rules_2,"data.frame")

# Get the frequnt itemsets and put it as dataframe
frequentItems <- eclat (Groceries, parameter = list(supp = 0.01, minlen=2, maxlen = 15)) # increase minlen if you want to see more items.
freqItems_df <- as(frequentItems, "data.frame")
freqItems_df <- freqItems_df[order(-freqItems_df$support),]

# remove the "{" and "}"
itms <- gsub("^\\{|\\}$","", as.character(freqItems_df$items))  # remove the "{" and "}"

# save as a data.frame
ncols <- max(sapply(itms, FUN=function(x){length(unlist(strsplit(x, ",")))}))
trans_df <- reshape2::colsplit(itms, pattern=",", names=paste0("col", 1:ncols))

itemsets_df <- data.frame(freqItems_df, trans_df)

# Get the support for all individual items and combos.

# convert df to transactions.
trans <- as(trans_df, "transactions")
inspect(head(trans))







