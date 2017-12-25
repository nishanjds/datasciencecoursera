# Question-01
# The American Community Survey distributes downloadable data about United 
# States communities. Download the 2006 microdata survey about housing for the 
# state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#
# and load the data into R. The code book, describing the variable names is 
# here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#
# Create a logical vector that identifies the households on greater than 10 
# acres who sold more than $10,000 worth of agriculture products. Assign that 
# logical vector to the variable agricultureLogical. Apply the which() function 
# like this to identify the rows of the data frame where the logical vector is 
# TRUE.
# which(agricultureLogical)
# What are the first 3 values that result?
# Solution:

# store the url 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

# download the file
download.file(url, destfile = 'ss06hid.csv', method='curl')

# import required libraries
library(data.table)

# read the file
df <- fread('ss06hid.csv')

# logical vector identifies the households on greater than 10 
# acres who sold more than $10,000 worth of agriculture products
agricultureLogical <- df$ACR == 3 & df$AGS==6

# print the result
print(head(which(agricultureLogical), 3))

# Question-02
# Using the jpeg package read in the following picture of your instructor into R
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
#
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the 
# resulting data? (some Linux systems may produce an answer 638 different for 
# the 30th quantile)

# load the required libraries
library(jpeg)

# store the url 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"

# download the file
download.file(url, destfile = 'jeff.jpg', method='curl')

# read the jpeg
img <- jpeg::readJPEG(source = 'jeff.jpg', native=TRUE)

# compute the quantiles
quantile(img, probs = c(.3,.8))

# Question-03
# Load the Gross Domestic Product data for the 190 ranked countries in this 
# data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is 
# last). What is the 13th country in the resulting data frame?
#    
# Original data sources:
# 1) http://data.worldbank.org/data-catalog/GDP-ranking-table
# 2) http://data.worldbank.org/data-catalog/ed-stats
# Solution:

# import the awesome library
library(dplyr)

# directly load the the dataset
# 1) First 4 lines can be removed as they are messy
# 2) Interested in first 190 rows
# 3) 3rd column is an empty column, thus, we do not need it.
gdp <-
    fread(input = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv', 
          skip = 4,
          nrows= 190,
          select=c(1,4,2,5),
          col.names = c('country_code', 'country', 'rank', 'economy'))
ed <- fread(input='https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv')

# merge the gdp and ed based on country code
df <- merge(gdp,ed, by.x='country_code', by.y='CountryCode')

# print the mathced number of rows
print(nrow(df))

# sort the df in descending order by GDP rank
sorted_df <- arrange(df, desc(rank))

# print the 13th country in the df
print(sorted_df[13,'country'])

# Question-04
# What is the average GDP ranking for the "High income: OECD" and 
# "High income: nonOECD" group?
# Solution:

# find the average GDP ranking by Income group and filter the results for
# "High income: OECD" and "High income: nonOECD"
result <-   sorted_df %>% 
            select(rank, "Income Group") %>%
            group_by(`Income Group`) %>%
            summarise(mean=mean(rank)) %>%
            filter(`Income Group` %in% 
                       c("High income: OECD", "High income: nonOECD"))
    
# print the result
print(result)

# Question-05:
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus 
# Income.Group. How many countries are Lower middle income but among the 
# 38 nations with highest GDP? 

# Create a column that stores the qunatile group where the row belongs.
sorted_df$quant_group <- cut2(sorted_df$rank, g=5)

# Print the number of countries that are Lower middle income but among the 
# 38 nations with highest GDP
print(nrow(filter(sorted_df,
                  quant_group=='[  1, 39)', 
                  `Income Group`=='Lower middle income')))


