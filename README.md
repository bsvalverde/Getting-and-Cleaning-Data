# Getting-and-Cleaning-Data
##Course project

###You should create one R script called run_analysis.R that does the following.

The first thing to do is download and unzip the data files.

	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "dataset.zip")
	unzip("dataset.zip")
	oldwd <- getwd()
	setwd(file.path(oldwd, "UCI HAR Dataset"))

###1. Merges the training and the test sets to create one data set.

Each of the tables is read and they are subsequently merged.

	test <- read.table(file.path(".", "test", "X_test.txt"))
	train <- read.table(file.path(".", "train", "X_train.txt"))
	data <- rbind(test, train)

###2. Extracts only the measurements on the mean and standard deviation for each measurement.
###4. Appropriately labels the data set with descriptive variable names.

The column labels are read from the appropriate file so the correct variables may be identified. The names are set so only one filter must be applied. A logical vector is obtained from the grepl function, which is used to select the desired variables.

	labels <- read.table("features.txt")
	labels <- labels[,2]
	names(data) <- labels
	data <- data[, grepl("mean|std", labels)]

###3. Uses descriptive activity names to name the activities in the data set.

The files that identify which activity each row is associated with are read and transformed into an unified table. The dplyr library is loaded so the mutate function can be used. For each row, the name of the activity is looked upon in the appropriate file. These names are then inserted into the dataset.

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

###5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The files that identify the subjects are read and inserted into the dataset. It is then grouped according to subject and activity.

	testSubjects <- read.table(file.path(".", "test", "subject_test.txt"))
	trainSubjects <- read.table(file.path(".", "train", "subject_train.txt"))
	subjects <- rbind(testSubjects, trainSubjects)
	names(subjects) <- "Subject"
	data2 <- cbind(subjects, data)
	data2 <- as_tibble(data2)
	data2 <- group_by(data2, Subject, Activity)

Finally, the datasets are written into files. the summarise_all function is used to apply the mean function to all variables according to the previously defined groups.

	setwd(oldwd)
	write.table(data, "tidydataset.txt")
	write.table(summarise_all(data2, funs(mean)), "tidydataset2.txt")