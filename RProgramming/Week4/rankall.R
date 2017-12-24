rankall <- function(outcome, num = "best") {
    ## Read outcome data
    df <- read.csv('outcome-of-care-measures.csv', colClasses = "character")
    ## Define the col indexes of outcomes
    cols_outcome <- c('heart attack'=11, 'heart failure'=17, 'pneumonia'=23)
    
    ## Check that outcome is valid
    if (!outcome %in% names(cols_outcome)) {
        stop('invalid outcome')
    }
    
    ## Retrieve the index of the given outcome column 
    outcome_index  <- cols_outcome[[outcome]]
    ## Select the required columns where the state matches the given state
    req_df <- df[, c(2, 7, outcome_index)]
    ## Convert the outcome column as numeric
    req_df[,3] <- as.numeric(req_df[,3])
    ## Remove the rows where the outcome columns has value of NA
    req_df <- req_df[!is.na(req_df[,3]), ]
    ## Set shorter column names
    names(req_df) <- c('hospital', 'state', 'rate')
    ## Sort the data with respect to state, rate and hospital columns
    req_df <- req_df[order(req_df$state, req_df$rate, req_df$hospital),]
    
    ## Function that retrieves the row for the particular rank
    get_row_by_rank <- function(x, rank) {
        state <- x[1,2]
        hospital <- NULL
        row <- NULL
        if (rank=='best') row <- 1
        else if (rank=='worst') row <- nrow(x)
        else if (is.numeric(rank) & (rank > 0) & (rank < nrow(x)+1)) row <- rank
        else hospital <- NA
        if(!is.null(row)) hospital <- x[row, 1]
        cbind.data.frame(hospital,state)        
    }
    
    ## For each state, find the hospital of the given rank
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    result <- do.call(rbind, lapply(split(req_df, req_df$state), get_row_by_rank, num))    
}

# print(head(rankall("heart attack", 20), 10))
# print(tail(rankall("pneumonia", "worst"), 3))
# print(tail(rankall("heart failure"), 10))