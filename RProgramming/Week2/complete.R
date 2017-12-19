complete <- function(directory, id=1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files
        
        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return a data frame of the form:
        ## id   nobs
        ## 1    117
        ## 2    1041
        ## ...
        ## where 'id' is the monitor ID number and 'nobs' is the number
        ## of complete cases
        
        # Initialise empty vectors for both id and nobs columns
        col_id <- c()
        col_nobs <- c()
        
        for (i in id) {
                # Create a file path with respect to id
                file_path <- sprintf("%s/%03d.csv", directory, i)
                # Read the CSV file pointed by the file_path into df
                df <- read.csv(file_path)
                # Filter the df by removing the rows contains NA values, where
                # NA should not be in both "sulfate" and "nitrate" columns
                df <- df[complete.cases(df[,2:3]), ] 
                col_id <- c(col_id, i)
                col_nobs <- c(col_nobs, nrow(df))
        }
        
        # Create a dataframe using both col_id and col_nobs vectors
        final_df <- data.frame(id=col_id, nobs=col_nobs)
        return(final_df)
}

# Testing the complete function 
# Test - 01 , Expected Result 
##   id nobs
## 1  1  117
print(complete("specdata", 1))
# Test - 02 , Expected Result 
##   id nobs
## 1  2 1041
## 2  4  474
## 3  8  192
## 4 10  148
## 5 12   96
print(complete("specdata", c(2, 4, 8, 10, 12)))
# Test - 03 , Expected Result 
##   id nobs
## 1 30  932
## 2 29  711
## 3 28  475
## 4 27  338
## 5 26  586
## 6 25  463
print(complete("specdata", 30:25))
# Test - 04 , Expected Result 
##   id nobs
## 1  3  243
print(complete("specdata", 3))