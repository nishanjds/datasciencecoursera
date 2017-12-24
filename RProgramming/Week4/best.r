best <- function(state, outcome) {
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
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    high_mortality_df <- req_df[req_df[,2]==min(req_df[,2]), ]
    ## Sort the result based on the hospital name and return the first row
    high_mortality_df[order(high_mortality_df[,1]),][,1]
}

# print(best("TX", "heart attack"))
# print(best("TX", "heart failure"))
# print(best("MD", "heart attack"))
# print(best("MD", "pneumonia"))
# print(best("SC", "heart attack"))
# print(best("BB", "heart attack"))
# print(best("NY", "hert attack"))