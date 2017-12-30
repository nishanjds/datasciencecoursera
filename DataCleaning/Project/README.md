# Getting and Cleaning Data Course Project

One of the most exciting areas in all of data science right now is wearable computing - see for example this [article][1] . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data used in this project was collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the [site][2] where the data was obtained.

The main purpose of this project is **cleaning the downloaded data set to create an independent tidy data set** for data analysis. As the end products of this project following files were produced:

* `CodeBook.md`: Describes all the variables in the tidy data set and the pre-processing steps perfomed on the original data.
* `run_analysis.R`: The R script that performs the cleaning process on the retrieved data and creates an independent tidy data set as a result.
* `tidy_data.txt`: The tidy dataset resulted from the script.

# Manual

Running the `run_analsis.R` script will perform the following steps:

1. Set the location of the script as the current working directory.
2. Downloads the required zip file containing the dataset and unzips in the working directory.
3. Loads all relevant data from the files.
4. Merges the training and the test sets to create one data set.
5. Extracts only the measurements on the mean and standard deviation for each measurement.
6. Uses descriptive activity names to name the activities in the data set
7. Appropriately labels the data set with descriptive variable names.
8. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
9. Writes the tidy data set to `tidy_data.txt` file.

The script requires the following libraries:
* `rstudioapi`: R studio api
* `data.table`: Extension of 'data.frame' that performs better with large data
* `dplyr`: A fast, consistent tool for working with data frame

[1]: http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/
[2]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

