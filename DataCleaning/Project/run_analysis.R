################################################################################
#
# Date          : 26/12/2017
# Author        : Nishanthan Kamaleson
# Description   : Cleaning the Human Activity Recognition Using Smartphones
#                 Dataset and Producing a Tidy dataset
# URL           : https://d396qusza40orc.cloudfront.net/
#                 getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
################################################################################


################################################################################
# PRE-STEP 01: Import the required libraries
################################################################################

# R studio api
library(rstudioapi)

# Extension of 'data.frame' that performs better with large data
library(data.table)

# A fast, consistent tool for working with data frame
library(dplyr)

################################################################################
# PRE-STEP 02: Download the dataset
################################################################################

# Set the parent directory of this script as working directory
setwd(dir = dirname(getActiveDocumentContext()$path))

# Url of the dataset
url <- paste0('https://d396qusza40orc.cloudfront.net/getdata%2F',
             'projectfiles%2FUCI%20HAR%20Dataset.zip')

# Name of the zip file containing the dataset
zip_file_name <- 'UCI HAR Dataset.zip'

# Download the zip file if it does not exist in the current working directory
if (!file.exists(zip_file_name)) {
    download.file(url, destfile = zip_file_name, method = 'curl')
}

# Unzip the downloaded zip file
unzip(zipfile = zip_file_name, overwrite = TRUE)

# Name of the root directory containing the dataset
root_dir <- 'UCI HAR Dataset'

################################################################################
# PRE-STEP 03: Read the relevant files
################################################################################

# Read training datasets
X_train <- fread(paste0(root_dir,'/train/X_train.txt'), data.table = FALSE)
y_train <- fread(paste0(root_dir,'/train/y_train.txt'),
                 col.names = c('activityId'), data.table = FALSE)
subject_train <- fread(paste0(root_dir,'/train/subject_train.txt'),
                       col.names = c('subjectId'), data.table = FALSE)

# Read test datasets
X_test <- fread(paste0(root_dir,'/test/X_test.txt'), data.table = FALSE)
y_test <- fread(paste0(root_dir,'/test/y_test.txt'),
                col.names = c('activityId'), data.table = FALSE)
subject_test <- fread(paste0(root_dir,'/test/subject_test.txt'),
                      col.names = c('subjectId'), data.table = FALSE)

# Read the features
# NOTE: some feature names are duplicated
#       e.g. : fBodyAcc-bandsEnergy()-1,16 is duplicated 3 times
#       unique features: 477 and duplicated features: 84 
features <- fread(paste0(root_dir,'/features.txt'),
                  select = 2,
                  data.table = FALSE)

# Read the activity labels 
activity_labels <- fread(paste0(root_dir,'/activity_labels.txt'),
                         col.names = c('activityId', 'activityLabel'),
                         data.table = FALSE)

# Assign column names to X
colnames(X_train) <- features[,1]
colnames(X_test) <- features[,1]

################################################################################
# STEP 01: Merges the training and the test sets to create one data set
################################################################################

# Merge train data sets
merged_train <- cbind(subject_train, X_train, y_train)

# Merge test data sets
merged_test <- cbind(subject_test, X_test, y_test)

# Merge both test and train
merged_data <- rbind(merged_train,merged_test)

################################################################################
# STEP 02: Extracts only the measurements on the mean and standard deviation 
#          for each measurement
################################################################################

# Get all the column names of merged data
col_names <- colnames(merged_data)

# Find the column ids with terms 'mean' or 'std' in their name and
# the first (subjectId) and last (activityId) columns
selected_cols <- c(1, grep('mean|sd', col_names), length(col_names))

# Keep only the relevant columns of the data set
merged_data <- merged_data[,selected_cols]

################################################################################
# STEP 03: Uses descriptive activity names to name the activities in the
#          data set
################################################################################

# Perform inner join on the data frames merged_data and activity_labels 
# based on activity_id column
merged_data <- inner_join(merged_data, activity_labels, by = 'activityId')

# Remove the acitivityId column from the merged_data as activity_labels holds
# the same information
merged_data$activityId <- NULL

################################################################################
# STEP 04: Appropriately labels the data set with descriptive variable names
################################################################################

# Get all the column names of the merged_data
col_names <- colnames(merged_data)

######################################################################
# Prefix of the column names are composed using following key factors:
# 1. Domain: time or frequency
# 2. MotionComponent: body or gravity
# 3. Sensor: accelerometer or gyroscope            
######################################################################

# Replace Domain values
col_names <- gsub('^t',"timeDomain", col_names)
col_names <- gsub('^f',"freqDomain", col_names)

# Replace Sensor names, and Magnitude
col_names <- gsub('Acc',"Accelerometer", col_names)
col_names <- gsub('Gyro',"Gyroscope", col_names)
col_names <- gsub('Mag',"Magnitude", col_names)

# Fix the typo: 'Body' repeated twice
col_names <- gsub('BodyBody', 'Body', col_names)

# Remove all non alphabets
col_names <- gsub('[^A-Za-z]', '', col_names)

# Replace all statistical methods
col_names <- gsub('mean', 'Mean', col_names)
col_names <- gsub('std', 'StdDev', col_names)

# Assign the descriptive variables names to merged_data
colnames(merged_data) <- col_names

################################################################################
# STEP 05: Create a second, independent tidy data set with the average of each 
#          variable for each activity and each subject.
################################################################################

# Convert both activityLabel and subjectId coulmns as factors
merged_data$subjectId <- as.factor(merged_data$subjectId)
merged_data$activityLabel<- as.factor(merged_data$activityLabel)

# Group merged_data by subject and activity columns, then summarise all other 
# columns using mean function
tidy_data <- merged_data %>%
             group_by(subjectId,activityLabel) %>%
             summarise_all(mean, na.rm=TRUE)

################################################################################
# POST-STEP 06: Write the tidy data to a file
################################################################################

# Save the the tidy data as a text file
write.table(tidy_data, file='tidy_data.txt', row.names = FALSE)