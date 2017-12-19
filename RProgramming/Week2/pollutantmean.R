pollutantmean <- function(directory, pollutant, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating 
        ## the location of the CSV files
        
        ## 'pollutant' is a character vector of length 1 indicating 
        ## the name of the pollutant for which we will calculate the
        ## mean; either "sulfate" or "nitrate"
        
        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return the mean of the pollutant across all monitors list
        ## in the 'id' vector (ignoring NA values)
        ## NOTE : Do not round the result!
        
        # Create a character vector of file paths with length equal to
        # the length of id integer vector
        file_paths <- sprintf("%s/%03d.csv", directory, id)
        
        # Declare the data frame to store all the data
        df <- data.frame(Date=strptime(character(), '%Y-%m-%d'), sulfate=numeric(), nitrate=numeric(), ID=integer())
        
        # Read all the files individually and append it to the data 
        # frame df
        for (p in file_paths) {
                df <- rbind(df, read.csv(p))
        }
        
        # Compute the mean of the given pollutant across all monitors
        return(mean(df[[pollutant]], na.rm = TRUE))
} 

# Testing the pollutant function 
# Test - 01 , Expected Result : 4.064128
print(sprintf("Expected: %f and Actual: %f", 4.064128, pollutantmean("specdata", "sulfate", 1:10))) 
# Test - 02 , Expected Result : 1.706047
print(sprintf("Expected: %f and Actual: %f",1.706047, pollutantmean("specdata", "nitrate", 70:72)))
# Test - 03 , Expected Result : 1.280833
print(sprintf("Expected: %f and Actual: %f",1.280833, pollutantmean("specdata", "nitrate", 23)))