download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "dataset.zip")
unzip("dataset.zip")
oldwd <- getwd()
setwd(file.path(oldwd, "UCI HAR Dataset"))
test <- read.table(file.path(".", "test", "X_test.txt"))
train <- read.table(file.path(".", "train", "X_train.txt"))
data <- rbind(test, train)
labels <- read.table("features.txt")
labels <- labels[,2]
names(data) <- labels
data <- data[, grepl("mean|std", labels)]
testActivities <- read.table(file.path(".", "test", "y_test.txt"))
trainActivities <- read.table(file.path(".", "train", "y_train.txt"))
activities <- rbind(testActivities, trainActivities)
library(dplyr)
activities <- as_tibble(activities)
names(activities) <- "code"
activityLabels <- read.table("activity_labels.txt")
activityLabels <- activityLabels[,2]
activities <- mutate(activities, Activity = activityLabels[code])
data <- cbind(activities[,2], data)
testSubjects <- read.table(file.path(".", "test", "subject_test.txt"))
trainSubjects <- read.table(file.path(".", "train", "subject_train.txt"))
subjects <- rbind(testSubjects, trainSubjects)
names(subjects) <- "Subject"
data2 <- cbind(subjects, data)
data2 <- as_tibble(data2)
data2 <- group_by(data2, Subject, Activity)
setwd(oldwd)
write.table(data, "tidydataset.txt", row.names = FALSE)
write.table(summarise_all(data2, funs(mean)), "tidydataset2.txt", row.names = FALSE)
