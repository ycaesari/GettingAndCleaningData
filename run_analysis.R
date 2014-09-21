## Please note, each command is prefixed with a printout that describes what the command is going to do.
## This serves both as a ducumentation and enables to see the script progress.

###################################################################
######## Read general tables: activity and features ###############
###################################################################

print("Reading activities...")
activities <- read.table("activity_labels.txt", col.names=c("activityID", "activityName"), header=FALSE);

print("Reading features...")
features <- read.table("features.txt", col.names=c("featureID", "featureName"), header=FALSE);

###############################################################################################
######## Read the train set and combine it with the activity and subject columns ##############
###############################################################################################

print("Reading train set...")
train_set <- read.table("train/X_train.txt", header=FALSE);

print("Reading train labels...")
train_labels <- read.table("train/y_train.txt", header=FALSE);

print("Reading train subjects...")
train_subjects <- read.table("train/subject_train.txt", header=FALSE);

print("Join train tables - set, labels, and subjects...")
train_records <- cbind(train_subjects, train_labels, train_set);

##############################################################################################
######## Read the test set and combine it with the activity and subject columns ##############
##############################################################################################

print("Reading test set...")
test_set <- read.table("test/X_test.txt", header=FALSE);

print("Reading test labels...")
test_labels <- read.table("test/y_test.txt", header=FALSE);

print("Reading test subjects...")
test_subjects <- read.table("test/subject_test.txt", header=FALSE);

print("Join test tables - set, labels, and subjects...")
test_records <- cbind(test_subjects, test_labels, test_set);

################################################################################
######## concatenate the train and test sets and add titles to columns #########
################################################################################

print("Join test records and train records...")
all_records <- rbind(test_records, train_records);

print("Title all_records set")
names(all_records) <- c("subjectID", "activityID", as.vector(features$featureName));

################################################################################
######### Add the activity name column, merging on the activityID ##############
######### activities has the columns: activityID and activityName ##############
################################################################################

print("add the activityName, use join");
all_records_resolved <- merge(activities, all_records);

####################################################################################
######### Retain only relevant columns, only those with mean or avg   ##############
######### Of course, keep the subjectID and activityName. we assume   ##############
######### that titles with mean() and std() are the ones that we want ##############
####################################################################################

print("Extracting only the mean() and std() measurements and the subjectID and activityName columns...")
relevantColumns <- grep("subjectID|activityName|-mean\\(\\)|-std\\(\\)", names(all_records_resolved));
all_records_subset <- all_records_resolved[, relevantColumns];

########################################################################################
######### How covenient, a nice method named aggregates applies a FUN   ################
######### (in this case, mean) to all column based on grouping elements ################
######### (in this case, subjectID and activityName)                    ################
########################################################################################

print("Creating an independent dity data set with the average of each variable for wach activity and each subject...")
avg_over_subject_activity <- aggregate(. ~ subjectID + activityName, data=all_records_subset, mean);

########################################################################################
######### Header names are the originals, and we want then to signify   ################
######### it is an average                                              ################
########################################################################################

print("Replacing header names from original measurments to a name signifying that this is an average...")
names_avg_over_subject_activity <- names(avg_over_subject_activity);
names_avg_over_subject_activity <- sub("-mean\\(\\)", "-AvgMean()", names_avg_over_subject_activity);
names_avg_over_subject_activity <- sub("-std\\(\\)", "-AvgStd()", names_avg_over_subject_activity);
names(avg_over_subject_activity) <- names_avg_over_subject_activity;

###################################################################
######### Last thing: write the tidy file to disk. ################
###################################################################

print("Writing the final tidy data set...")
write.table(avg_over_subject_activity, "avg_over_subject_activity.txt", row.name=FALSE);

