# arules

library(arules)
data("Groceries")
inspect(head(Groceries))
rules_2 <- apriori(Groceries)

# trans2 <- read.transactions("AU_purchase_categories.txt", sep="\t",rm.duplicates=T)
# rules_2 <- apriori(trans2,parameter = list(supp = 0.000075,conf=0.3,minlen=3,maxlen=3) )
# rules_df2 <- as(rules_2,"data.frame")

# Get the frequent item 1 item at a time.
frequentItems_ones <- eclat(Groceries, parameter = list(supp = 0.01, minlen=1, maxlen = 1)) # increase minlen if you want to see more items.
freqItems_ones_df <- as(frequentItems_ones, "data.frame")
freqItems_ones_df <- freqItems_ones_df[order(-freqItems_ones_df$support),]

# Get the frequent items - 2 items at a time.
frequentItems_twos <- eclat(Groceries, parameter = list(supp = 0.01, minlen=2, maxlen = 2)) # increase minlen if you want to see more items.
freqItems_twos_df <- as(frequentItems_twos, "data.frame")
freqItems_twos_df <- freqItems_twos_df[order(-freqItems_twos_df$support),]

# Get the frequent itemsets with 3 or more than items and put it as dataframe
frequentItems <- eclat(Groceries, parameter = list(supp = 0.01, minlen=3, maxlen = 15)) # increase minlen if you want to see more items.
freqItems_df <- as(frequentItems, "data.frame")
freqItems_df <- freqItems_df[order(-freqItems_df$support),]

# a = frequentItems_twos[1]
# b = frequentItems[1]

'%is.in%' <- function(a, b){
  if(class(a) == "itemsets" & class(b) == "itemsets"){
    a_df <- as(a, "data.frame") 
    b_df <- as(b, "data.frame")
    a_item <- gsub("^\\{|\\}$","", as.character(a_df[1, 1]))  # remove the "{" and "}"
    a_items <- unlist(strsplit(a_item, ","))
    b_item <- gsub("^\\{|\\}$","", as.character(b_df[1, 1]))  # remove the "{" and "}". Puts all items as one.
    b_items <- unlist(strsplit(b_item, ","))
  }else{
    a_item <- gsub("^\\{|\\}$","", as.character(a))  # remove the "{" and "}"
    a_items <- unlist(strsplit(a_item, ","))
    b_item <- gsub("^\\{|\\}$","", as.character(b))  # remove the "{" and "}". Puts all items as one.
    b_items <- unlist(strsplit(b_item, ","))
  }
  return(all(a_items %in% b_items))
} 

# frequentItems_ones[1]  %is.in% frequentItems[1]
# lhs = frequentItems_ones[1]
# rhs = frequentItems[1]

confidence <- function(lhs, rhs){
  if(class(lhs) == "itemsets" & class(rhs)=="itemsets"){
    if(lhs %is.in% rhs){
      lhs_df <- invisible(as(lhs, "data.frame"));
      rhs_df <- invisible(as(rhs, "data.frame"));
      support_lhs <- lhs_df[1, 2]
      support_rhs <- rhs_df[1, 2]
      return(support_rhs/support_lhs)
    }else{
      return("Error: the lhs item/s should be present in rhs")
    }
  }else{
    return("Error: the lhs and rhs arguments must be itemsets.")
  }
}

# Make Rules with multiple items in RHS
# Get the frequent item 1 item at a time.
transactions <- Groceries
makeRulesDf <- function(transactions, supp=0.01, maxlhs=2){
  if(class(transactions) == "transactions"){
    frequentItems_ones <- invisible(eclat (transactions, parameter = list(supp = 0.01, minlen=1, maxlen = 1))) # increase minlen if you want to see more items.
    freqItems_ones_df <- as(frequentItems_ones, "data.frame")
    freqItems_ones_df <- freqItems_ones_df[order(-freqItems_ones_df$support),]
    
    # Get the frequent items - 2 items at a time.
    frequentItems_twos <- invisible(eclat (transactions, parameter = list(supp = 0.01, minlen=maxlhs, maxlen = maxlhs))) # increase minlen if you want to see more items.
    freqItems_twos_df <- as(frequentItems_twos, "data.frame")
    freqItems_twos_df <- freqItems_twos_df[order(-freqItems_twos_df$support),]
    
    # Get the frequent itemsets with 3 or more than items and put it as dataframe
    frequentItems <- invisible(eclat (transactions, parameter = list(supp = 0.01, minlen=3, maxlen = 15))) # increase minlen if you want to see more items.
    freqItems_df <- as(frequentItems, "data.frame")
    freqItems_df <- freqItems_df[order(-freqItems_df$support),]  
    
    # Make Rules DF
    lhsDf <- rbind(freqItems_ones_df, freqItems_twos_df)
    lhsDf <- lhsDf[order(-lhsDf$support), ]
    
    # Subset lhs items to suppot cutoff
    lhsDf <- lhsDf[lhsDf$support > supp, ]
    
    # Adding RHS for each row in LHS
    rulesDf <- data.frame()
    rhsDf <- freqItems_df  # init RHS items
    for(i in 1:nrow(lhsDf)){
      lhs <- (lhsDf[i, 1])
      rulesForCurrentLHS <- data.frame()
      for(ii in 1:nrow(rhsDf)){
        if(lhs %is.in% rhsDf[ii, 1]){  # if the item in lhs is present in the RHS itemset
          temp <- data.frame(lhsDf[i, ], rhsDf[ii, ], confidence=rhsDf[ii, 2]/lhsDf[i, 2])
          rulesForCurrentLHS <- rbind(rulesForCurrentLHS, temp)
        }
      }  # complete iterating all items in RHS
      rulesDf <- rbind(rulesDf, rulesForCurrentLHS)
    }  # complete iterating all items in LHS
    rulesDf <- setNames(rulesDf, c("lhs", "lhs_support", "rhs", "lhs_rhs_support", "confidence"))
    
    # Calculate num items in lhs and rhs, and remove rules that contain only 1 item in RHS.
    count_items <- function(x){
      no_brac <- gsub("^\\{|\\}$", "", as.character(x))
      return(length(unlist(strsplit(no_brac, ","))))
    }
    rulesDf$lhs_num <- sapply(rulesDf$lhs, count_items)
    rulesDf$rhs_num <- sapply(rulesDf$rhs, count_items)
    rulesDf <- rulesDf[which((rulesDf$rhs_num - rulesDf$lhs_num) > 1), ]
    # rulesDf <- rulesDf[which((rulesDf$rhs_num - rulesDf$lhs_num) > 1), !names(rulesDf) %in% c("lhs_num", "rhs_num")]
    rulesDf <- rulesDf[order(-rulesDf$confidence), ]  # sort by rule's support
    
    # Remove the lhs item from rhs.
    remove_the_lhs_from_rhs <- function(x){
      x_lhs <- gsub("^\\{|\\}$", "", as.character(x['lhs']))
      x_rhs <- gsub("^\\{|\\}$", "", as.character(x['rhs']))
      lhs_items <- unlist(strsplit(x_lhs, ","))
      rhs_items <- unlist(strsplit(x_rhs, ","))
      new_rhs_items <- setdiff(rhs_items, lhs_items)
      paste0("{", paste0(new_rhs_items, collapse=","), "}")
    }
    rulesDf$rhs <- apply(rulesDf[, c('lhs', 'rhs')], 1,  remove_the_lhs_from_rhs)
    
    # Compute Lift
    all_supp <- eclat(transactions, parameter=list(minlen=min(rulesDf$rhs_num-rulesDf$lhs_num), maxlen=max(rulesDf$rhs_num-rulesDf$lhs_num), supp=0.01))
    all_supp_df <- as(all_supp, "data.frame")
    
    # Look up the all_supp_df table and get the 'support' for all itemsets in rulesDf$rhs.
    get_rhs_supp <- function(x){
      # check if current rulesDf$rhs is present in all_supp_df[, 1]
      present.in <- function(y){
        x %is.in% y  # using %is.in% instead of %in% because, it will give correct result even if order changes.
      }
     rowindex <- which(sapply(all_supp_df[, 1], present.in))  # find the row-index of current rulesDf$rhs in all_supp_df
     all_supp_df[rowindex, "support"]
    }
    
    # create a dataframe of all unique rhs's and its support.
    uniqueRhs <- data.frame(rhs=unique(rulesDf$rhs), support=numeric(length(unique(rulesDf$rhs))))
    uniqueRhs$support <- sapply(uniqueRhs$rhs, get_rhs_supp)  # get the support for all RHSs
    
    # Lookup the uniqueRhs table and fill in the support for all RHSs in rulesDf
    rulesDf$rhs_support <- uniqueRhs[match(rulesDf$rhs, uniqueRhs$rhs), "support"]
    rulesDf$lift <- rulesDf$confidence/rulesDf$rhs_support  # compute lift
    return(rulesDf[order(-rulesDf$lift), c("lhs", "rhs", "lhs_support", "rhs_support", "confidence", "lift")])
  }else{
    return("Error: makeRulesDf accepts objects of class 'transactions'")
  }
}

a <- makeRulesDf(Groceries)



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









