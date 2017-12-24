# QUESTION-01
# The American Community Survey distributes downloadable data 
# about United States communities. Download the 2006 
# microdata survey about housing for the state of Idaho using
# download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the 
# variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata/data
# /PUMSDataDict06.pdf
# 
# How many properties are worth $1,000,000 or more?
# Solution:


# store the url 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

# download the file
download.file(url, destfile = 'IdahoHousing.csv', method = 'curl')

# read the file into data frame
df <- read.csv('IdahoHousing.csv')

# according to the codebook VAL variable represents the 
# property worth and its value 24 represents the property
# worth $1,000,000 or more. 
# subset the data based on this info.
sub_df <- df[!is.na(df$VAL) & df$VAL==24, ]

# count the number of raws for the sub data frame
print(nrow(sub_df))

# QUESTION-02
# Use the data you loaded from Question 1. Consider the 
# variable FES in the code book. Which of the "tidy data" 
# principles does this variable violate?
# Answer:
#   Tidy data has one variable per column.

# QUESTION-03
# Download the Excel spreadsheet on Natural Gas Aquisition 
# Program here:
# https://d396qusza40orc.cloudfront.net/getdata/data
# /DATA.gov_NGAP.xlsx
#
# Read rows 18-23 and columns 7-15 into R and assign the 
# result to a variable called: dat
# What is the value of: sum(dat$Zip*dat$Ext,na.rm=T)
# original data source:
# http://catalog.data.gov/dataset/natural-gas-acquisition-program
# Solution:

# load the required library to read excel files
library('xlsx')

# store the url
url <- "https://d396qusza40orc.cloudfront.net/getdata/data/DATA.gov_NGAP.xlsx"

# download the file
download.file(url, destfile = 'gov_NGAP.xlsx', method = 'curl')

# read the file into a dataframe
df <- read.xlsx('gov_NGAP.xlsx', 1,rowIndex = 18:23, colIndex = 7:15, header = TRUE)

# execute and print the given statement
print(sum(dat$Zip*dat$Ext,na.rm=T))

# QUESTION-04
# Read the XML data on Baltimore restaurants from here:
# https://d396qusza40orc.cloudfront.net/getdata/data/restaurants.xml
#
# How many restaurants have zipcode 21231?
# Solution:

# load the required library to read the xml files
library(XML)

# store the url
url <- 'https://d396qusza40orc.cloudfront.net/getdata/data/restaurants.xml'

# download the xml file
download.file(url, destfile = 'restaurants.xml', method='curl')

# parse the xml
doc <- xmlTreeParse('restaurants.xml',useInternalNodes = TRUE)

# using xpath find the values of all the zipcode nodes
zipcodes <- xpathSApply(doc, '//zipcode',xmlValue)

# count the zipcodes that matches 21231
print(length(zipcodes[zipcodes=='21231']))

# QUESTION-05
# The American Community Survey distributes downloadable data
# about United States communities. Download the 2006 microdata
# survey about housing for the state of Idaho using download.file() 
# from here:
# https://d396qusza40orc.cloudfront.net/getdata/data/ss06pid.csv
#
# using the fread() command load the data into an R object DT
# The following are ways to calculate the average value of 
# the variable : pwgtp15
# broken down by sex. Using the data.table package, which 
# will deliver the fastest user time?
# Solution:

# import relevant library for profiling 
library('microbenchmark')

# store the url
url <- "https://d396qusza40orc.cloudfront.net/getdata/data/ss06pid.csv"

# download the file
download.file(url, destfile = 'ss06pid.csv', method='curl')

# read the file into data frame object DT using fread
DT <- data.table::fread('ss06pid.csv',data.table = TRUE)

res <- microbenchmark(opt1 = sapply(split(DT$pwgtp15,DT$SEX),mean), 
                opt2_1 = mean(DT[DT$SEX==1,]$pwgtp15), 
                opt2_2 = mean(DT[DT$SEX==2,]$pwgtp15), 
                opt3 = mean(DT$pwgtp15,by=DT$SEX),
                opt4 = tapply(DT$pwgtp15,DT$SEX,mean),
                opt5 = DT[,mean(pwgtp15),by=SEX],
                times=100            
)        

## Plot results:
boxplot(res)

## Pretty plot:
if (require("ggplot2")) {
    autoplot(res)
}
