## README.md

This is the repository holding the project files for the Coursera's Getting and Cleaning Data course.

In this repository, you'll find -

**README.md** - this file.

**run_analysis.R** - Code to create the tidy data set as required by the project. It is assumed that the zip file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip is already unzipped and its root is set as the current working directory. The file contains comments and it explains the transformations done in order to clean the data.

**CodeBook.md** - A code book that describes the variables, the data, and any transformations or work that I performed to clean the data.

**avg_over_subject_activity.txt** - The final tidy data set, also uploaded to the submission page.

In order to view this file, use the following commands in R -

```
data <- read.table("avg_over_subject_activity.txt", header = TRUE)
View(data) 
```