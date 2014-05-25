library(reshape2)

### Merge training and test sets to create one data set

width.read <- c(-1, 15)
data.measurements.train <- read.fwf("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", widths=rep(width.read, 561))
data.activity.train <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
data.subject.train <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
data.measurements.test <- read.fwf("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", widths=rep(width.read, 561))
data.activity.test <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
data.subject.test <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

data.merged.train <- cbind(data.subject.train, data.activity.train, data.measurements.train)
data.merged.test <- cbind(data.subject.test, data.activity.test, data.measurements.test)

data.merged <- rbind(data.merged.train, data.merged.test)

### Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", sep=" ", col.names=c("col", "measurement"))
features.vector.trim <- c(TRUE, TRUE, grepl("mean[(][)]", features$measurement)|grepl("std[(][)]", features$measurement))

data.trim <- data.merged[features.vector.trim]

features.label <- c("Subject", "Activity", as.character(features$measurement))[features.vector.trim]
features.label <- gsub("^t", "", features.label)
features.label <- gsub("^f", "", features.label)
features.label <- gsub("[()][)]", "", features.label)
features.label <- gsub("-", ".", features.label)

data.descriptive <- data.trim
names(data.descriptive) <- features.label

### Uses descriptive activity names to name the activities in the data set
### Appropriately labels the data set with descriptive activity names

label.activity <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", sep=" ", col.names=c("factor", "activity"))
data.descriptive$Activity <- factor(data.descriptive$Activity, labels=as.character(label.activity$activity))

### Creates a second, independent tidy data set with the average of each variable for each activity and each subject
data.tidy <- melt(data.descriptive, id=c("Subject", "Activity"))