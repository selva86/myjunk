# scraping with rvest
# install.packages("rvest")
# devtools::install_github("hadley/rvest")
library(rvest)
library(magrittr)
library(dplyr)
library(data.table)
library(httr)
setwd("/Users/selvaprabhakaran/Documents/Self/rwork/moneycontrol")
setwd("/Users/selvaprabhakaran/Documents/work/rwork/stocks_data")
# Setup
root_url <- "http://www.moneycontrol.com"

omit_urls <- c("http://www.moneycontrol.com/india/stockpricequote/bsesensex/bsesensex/BSE03", "",
               "http://www.moneycontrol.com/india/stockpricequote/index//",
               "http://www.moneycontrol.com/india/stockpricequote/bankspublicsector/sbibivnr/SBI20")

# Get urls of pages that contain scrips for stocks of all alphabets 
baseurl <- "http://www.moneycontrol.com/india/stockmarket/pricechartquote/"
alphabet_urls <- paste0(baseurl, LETTERS)

master_urls <- character()
alphabet_url <- alphabet_urls[1]
for(alphabet_url in alphabet_urls){
  html_alphabet_url <- read_html(alphabet_url)  # read alphabet's html
  # html_alphabet_url %>% html_nodes("a") %>% html_attrs(. , "class")
  a_nodes <- html_alphabet_url %>% html_nodes("a")   # all 'a' nodes.
  class_of_stock_urls <- "bl_12"  # class of the nodes that contain stock's urls.

  # Get stock urls for current alphabet
  stock_url_indexes <- a_nodes %>% html_attr("class") %>% `==`(class_of_stock_urls) %>% which
  current_alphabet_urls <- html_attr(a_nodes, "href")[stock_url_indexes]
  master_urls <- c(master_urls, current_alphabet_urls)
}

master_url <- master_urls[1]
master_url <- "http://www.moneycontrol.com/india/stockpricequote/pharmaceuticals/abbottindia/AI51"
master_url <- "http://www.moneycontrol.com/india/stockpricequote/miscellaneous/afenterprises/AFE01"

# remove omit urls.
master_urls <- setdiff(master_urls, omit_urls)

### Begin scraping! ------------------------------------------------------
master_stock_data <- data.table()  # init final output
iter <- 0
pb <- txtProgressBar(min=1, max = length(master_urls), style = 3, char=">")

for(master_url in setdiff(master_urls, master_stock_data$master_url)){
  cat(master_url, "\n")
  iter <- iter + 1
  setTxtProgressBar(pb, value = iter)
  html_stock <- read_html(master_url)
  
  ## Stock Attributes
  # Get all div nodes
  div_nodes <- html_nodes(html_stock, "div")  # all nodes
  div_nodes_classes <- html_attr(div_nodes, "class")  # all classes
  div_nodes_ids <- html_attr(div_nodes, "id")  # all classes
  
  # Get all span nodes
  span_nodes <- html_nodes(html_stock, "span")  # all nodes
  span_nodes_classes <- html_attr(span_nodes, "class")  # all classes
  span_nodes_ids <- html_attr(span_nodes, "id")  # all classes
  
  scripname_node <- div_nodes[which(div_nodes_classes == "FL gry10")]  # nodes with the class "FL gry10"
  scrip_string_combo <- html_text(scripname_node)  # get text
  
  # Get scrip names info
  scrip_names <- unlist(str_split(scrip_string_combo, pattern="[|]"))
  bse_scrip_name <- unlist(str_split(scrip_names[1], pattern="(:\\s)"))[2]
  nse_scrip_name <- unlist(str_split(scrip_names[2], pattern="(:\\s)"))[2]
  sector <- unlist(str_split(scrip_names[4], pattern="(:\\s)"))[2]
  
  # Get company name
  companyname_node <- div_nodes[which(div_nodes_classes == "b_42 PT5")]
  company_name <- html_text(companyname_node)
  
  # Get bse price
  bse_price_node <- div_nodes[which(div_nodes_ids == "Bse_Prc_tick_div")]
  bse_price <- html_text(bse_price_node)
  
  # Get nse price
  nse_price_node <- div_nodes[which(div_nodes_ids == "Nse_Prc_tick_div")]
  nse_price <- html_text(nse_price_node)
  
  # Get volumes
  bse_volume_node <- span_nodes[which(span_nodes_ids == "bse_volume")]
  bse_volume <- html_text(bse_volume_node)
  nse_volume_node <- span_nodes[which(span_nodes_ids == "nse_volume")]
  nse_volume <- html_text(nse_volume_node)
  
  # Get sentimeter score
  sentimeter_score_node <- span_nodes[which(span_nodes_classes == "pl_txt")]
  sentimeter_score <- html_text(sentimeter_score_node)
  
  # Get marketcap in crores
  key_metrics_div_node <- div_nodes[which(div_nodes_ids == "mktdet_1")]
  km_div_node_subnodes <- html_nodes(key_metrics_div_node, "div")
  km_div_node_subnodes_classes <- html_attr(km_div_node_subnodes, "class")
  key_sub_nodes <- km_div_node_subnodes[which(km_div_node_subnodes_classes == "FR gD_12")]
  key_metrics <- html_text(key_sub_nodes)
  
  market_cap_in_cr <- key_metrics[1]
  pe <- key_metrics[2]
  book_value <- key_metrics[3]
  dividend_perc <- key_metrics[4]
  market_lot <- key_metrics[5]
  industry_pe <- key_metrics[6]
  eps <- key_metrics[7]
  pc <- key_metrics[8]
  price_by_bookvalue <- key_metrics[9]
  div_yield_perc <- key_metrics[10]
  face_value <- key_metrics[11]
  deliverables_perc <- key_metrics[12]
  
  # Get SMA data
  sma_table_div_node <- div_nodes[which(div_nodes_classes == "FR w252")][1]
  sma_table_node <- html_nodes(sma_table_div_node, "table")
  sma_table_data_nodes <- html_nodes(sma_table_node, "td")
  sma_table_data_nodes_classes <- html_attr(sma_table_data_nodes, "class")
  sma_table_bse_data <- html_text(sma_table_data_nodes[which(sma_table_data_nodes_classes == "th05 gD_12")])
  sma_30_50_150_200_bse <- paste(setdiff(sma_table_bse_data, c("30", "50", "150", "200")), collapse=", ")
  sma_30_50_150_200_nse <- paste(html_text(sma_table_data_nodes[which(sma_table_data_nodes_classes == "th06 gD_12")]), collapse=", ")
  
  
  # replace no entries with NAs: If any length = 0, put it as NA
  
  
  # Assemble all data together  
  curr_stock_data <- list(bse_scrip_name, nse_scrip_name, sector, company_name, bse_price, nse_price, bse_volume, nse_volume, sentimeter_score,
                                market_cap_in_cr, pe, book_value, dividend_perc, market_lot, industry_pe, eps, pc, price_by_bookvalue, div_yield_perc, 
                                face_value, deliverables_perc, sma_30_50_150_200_bse, sma_30_50_150_200_nse, master_url)
  
  curr_stock_data_full <- lapply(curr_stock_data, function(x){ifelse(length(x) == 0,"NA", x)})
  
  # Append to master dataset
  master_stock_data <- rbind(master_stock_data, curr_stock_data_full, use.names=F)
  
}

setnames(master_stock_data, names(master_stock_data), c("bse_scrip_name", "nse_scrip_name", "sector", "company_name", "bse_price", "nse_price", "bse_volume", "nse_volume", "sentimeter_score",
                                                        "market_cap_in_cr", "pe", "book_value", "dividend_perc", "market_lot", "industry_pe", "eps", "pc", "price_by_bookvalue", "div_yield_perc", 
                                                        "face_value", "deliverables_perc", "sma_30_50_150_200_bse", "sma_30_50_150_200_nse", "master_url"))

# write.csv(master_stock_data, paste0("master_stock_data_",round(Sys.time(), "days"), ".csv"), row.names = F)
master_stock_data <- fread("/Users/selvaprabhakaran/Documents/Self/rwork/moneycontrol/master_stock_data_2015-12-02.csv")

####------------------------------------------------------------------------------------------------


### Get ALL yahoo finance symbols id for all stocks. --------------------------
lookup_url <- "https://in.finance.yahoo.com/lookup?s=A&m=IN"  # general format of a url to lookup.
lookup_urls <- paste0("https://in.finance.yahoo.com/lookup?s=", c("A", "E", "I", "O", "U"), "&m=IN")  # construct all alphabets urls.
lookup_url <- lookup_urls[1]

## Define functions.
start_session <- function(lookup_url=lookup_url){
  # start browser session
  uastring <- "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
  session <- html_session(lookup_url, user_agent(uastring))
  return(session)
}

get_table <- function(session=session){
  # Get data
  html_out <- read_html(session)
  html_tables <- html_nodes(html_out, "table")
  all_tables <- html_table(html_tables)
  
  # if table is present, return it.
  if(length(all_tables) > 1){
    curr_table <- all_tables[[2]]  # get the stocks data 
    return(curr_table)
  }
}


master_table <- data.table()
for(lookup_url in lookup_urls){
  # Start session
  session <- start_session(lookup_url = lookup_url)
  
  # Get table
  curr_table <- get_table(session)
  
  # update master table
  master_table <- rbind(master_table, curr_table)  
  
  # Click and follow the 'Next' button if it exists
  session <- try(follow_link(session, "Next"), silent=T)
  
  while(class(session) != "try-error"){
    # session <- start_session(lookupurl = lookupurl)  # Start session
    curr_table <- get_table(session)  # Get table
    master_table <- rbind(master_table, curr_table)  # update master table
    session <- try(follow_link(session, "Next"), silent=T)  # Click and follow the 'Next' button if it exists
    Sys.sleep(sample(1:3, 1))
    cat(nrow(master_table), "\n")
  }
  Sys.sleep(5)
}


all_company_names <- str_to_lower(master_stock_data$company_name)
str_detect()
aeiou <- sapply(all_company_names, function(x){str_detect(x, "[aeiou]")})
stocks_without_aeiou <- aeiou[aeiou==FALSE]  # scrape these stocks separately.

# Download data
yahoo_symbols <- unique(master_table$Symbol)
yahoo_symbol <- "APOLLOHOS.NS"
yahoo_symbol <- "GATI.NS"
faulty_symbols <- character()

# Download all stock quotes
pb <- txtProgressBar(min=0, max = length(yahoo_symbols), style=3)
iter <- 0
for(yahoo_symbol in yahoo_symbols){
  iter <- iter + 1
  setTxtProgressBar(pb, iter)
  url <- paste0("http://real-chart.finance.yahoo.com/table.csv?s=", yahoo_symbol)
  destfile <- paste0(yahoo_symbol,".csv")
  output <- try(read_html(url), silent = T)  # read the url
  if(class(output) == "try-error"){
    faulty_symbols <- c(faulty_symbols, yahoo_symbol)
  }else{
    # download.file(url, destfile = destfile)
    data_node <- html_nodes(output, "p")
    data <- html_text(data_node)
    daily_data <- read.table(text = data, sep="\n")
    daily_data_df <- read.delim(text = as.character(daily_data$V1), sep=",")
    write.csv(daily_data_df, destfile, row.names = F)
  }
}


