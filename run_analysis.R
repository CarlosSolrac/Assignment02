
##
##    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

##
##    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## You should create one R script called run_analysis.R that does the following.
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement.
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names.
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity
## and each subject.

require("plyr")
require("dplyr")



setwd("D:/zi386/Coursera/03_GettingAndCleaningData/Assignment02")

## Sorry about the lack of comments, I ran out of time. This is probably the lamest comment ever!

activity_labels <- read.csv(file = "data/activity_labels.txt", header = FALSE, sep = " ", as.is = TRUE)
names(activity_labels) <- c("ActivityLabelId", "ActivityLabel")

features <- read.csv(file = "data/features.txt", header = FALSE, sep = " ")
names(features) <- c("FeatureId", "Feature")

subject_train <- read.csv(file = "data/train/subject_train.txt", header = FALSE, sep = " ")
names(subject_train) <- c("SubjectId")

subject_test <- read.csv(file = "data/test/subject_test.txt", header = FALSE, sep = " ")
names(subject_test) <- c("SubjectId")


y_train <- read.csv(file = "data/train/y_train.txt", header = FALSE, sep = " ", as.is = TRUE)
names(y_train) <- c("ActivityLabelId")
y_train <- join_all(dfs = list(y_train, activity_labels))


y_test <- read.csv(file = "data/test/y_test.txt", header = FALSE, sep = " ")
names(y_test) <- c("ActivityLabelId")
y_test <- join_all(dfs = list(y_test, activity_labels))


x_test <- read.csv(file = "data/test/x_test.txt", header = FALSE, sep = " ")
names(x_test) <- features$Feature
isMeanStd <- grepl(pattern = "mean|std", x = names(x_test), ignore.case = TRUE)
x_test <- x_test[, isMeanStd]
x_test <- cbind(rep_len(x = y_test$ActivityLabel, length.out = nrow(x_test)), x_test)
names(x_test)[1] <- "ActivityLabel"
x_test <- cbind(rep_len(x = subject_test$SubjectId, length.out = nrow(x_test)), x_test)
names(x_test)[1] <- names(subject_test)[1]
x_test$SubjectId <- as.factor(x_test$SubjectId)


x_train <- read.csv(file = "data/train/x_train.txt", header = FALSE, sep = " ")
names(x_train) <- features$Feature
x_train <- x_train[, isMeanStd]
x_train <- cbind(rep_len(x = y_test$ActivityLabel, length.out = nrow(x_train)), x_train)
names(x_train)[1] <- "ActivityLabel"
x_train <- cbind(rep_len(x = subject_test$SubjectId, length.out = nrow(x_train)), x_train)
names(x_train)[1] <- names(subject_test)[1]
x_train$SubjectId <- as.factor(x_train$SubjectId)


allData <- rbind(x_train, x_test)



tidyData <- allData %>%
    group_by(SubjectId, ActivityLabel) %>%
    summarise_each(funs(mean(., na.rm=TRUE)))


write.table(x = tidyData, file = "tidyData.txt", append = FALSE, row.names = FALSE)
