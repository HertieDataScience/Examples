#################
# Scrape BBC Sochi Olympics Medals Table
# Christopher Gandrud
# 15 October 2014
#################

# Load packages
library(httr)
library(dplyr)
library(XML)

# URL with the medals table
URL <- 'http://www.bbc.com/sport/winter-olympics/2014/medals/countries'

#### Gather content and parse all tables ####
all_tables <- URL %>% GET() %>% content(as = 'parsed') %>% readHTMLTable()

# Identify medals table
names(all_tables) # the table does not have an ID

# Convert to a data frame
medals <- as.data.frame(all_tables)

#### Clean ####
# Drop unwanted variables
medals <- select(medals, -NULL.V1, -NULL.V7)

# Give new variable names
names(medals) <- c('country', 'gold', 'silver', 'bronze', 'total')

# Convert variable classes
medals$country <- as.character(medals$country)
for (i in 2:5) medals[, i] <- as.integer(medals[, i])

# Sort by total medals in descending order
medals <- arrange(medals, desc(total))
