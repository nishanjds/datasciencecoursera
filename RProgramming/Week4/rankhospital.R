rankhospital <- function(state, outcome, num = "best") {
    ## Read outcome data
    df <- read.csv('outcome-of-care-measures.csv', colClasses = "character")
    ## Define the col indexes of outcomes
    cols_outcome <- c('heart attack'=11, 'heart failure'=17, 'pneumonia'=23)
    
    ## Check that state and outcome are valid
    if (!state %in% df$State) {
        stop('invalid state')
    } else if (!outcome %in% names(cols_outcome)) {
        stop('invalid outcome')
    }
    
    ## Retrieve the index of the given outcome column 
    outcome_index  <- cols_outcome[[outcome]]
    ## Select the required columns where the state matches the given state
    req_df <- df[df[, 7]==state, c(2, outcome_index)]
    ## Convert the outcome column as numeric
    req_df[,2] <- as.numeric(req_df[,2])
    ## Remove the rows where the outcome columns has value of NA
    req_df <- req_df[!is.na(req_df[,2]), ]
    ## Set shorter column names
    names(req_df) <- c('Hospital.Name', 'Rate')
    ## Sort the data frame with respect to 'Rate' and 'Hospital.Name' columns
    req_df <- req_df[order(req_df['Rate'],req_df['Hospital.Name']),]
    ## Reset the index
    row.names(req_df) <- 1:nrow(req_df)
    
    ## Return hospital name in that state with the given rank
    ## 30-day death rate
    ## Define the ranks
    if (is.numeric(num)) {
        if (num < 1 & num > nrow(req_df)) {
            NA
        } else {
            return(req_df[num, 1])
        }
    } else {
        if (num=='best') {
            req_df[1, 1]
        } else if (num=='worst') {
            req_df[nrow(req_df), 1]
        } else {
            stop('invalid rank')
        }
    }
}

# print(rankhospital("TX", "heart failure", 4))
# print(rankhospital("MD", "heart attack", "worst"))
# print(rankhospital("MN", "heart attack", 5000))