corr <- function(directory, threshold = 0) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files
        
        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all
        ## variables) required to compute the correlation between
        ## nitrate and sulfate; the default is 0
        
        ## Return a numeric vector of correlations
        ## NOTE: Do not round the result!
        
        # Create an empty numeric vector
        cv <- vector(mode="numeric", length=0)

        for(id in 1:332) {
                # Create a file path with respect to id
                file_path <- sprintf("%s/%03d.csv", directory, id)
                # Read the CSV file pointed by the file_path into df
                df <- read.csv(file_path)
                # Filter the df by removing the rows contains NA values, where
                # NA should not be in both "sulfate" and "nitrate" columns
                df <- df[complete.cases(df[,2:3]), ] 
                if(nrow(df) > threshold) {
                        cv <- c(cv, cor(df$sulfate, df$nitrate))
                }
        }
        return(cv)
}   

# Sample Test Code
cr <- corr("specdata", 400)
print(head(cr))
print(summary(cr))
print(length(cr))