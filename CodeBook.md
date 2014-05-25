# Codebook for UCI HAR Dataset means and standard deviations

## Variables
 68 total

* Subject - The index of the subject of the observation.
* Activity - A descriptive factor denoting the activity of the observation.
* BodyAcc.mean/std.XYZ - From mean/std of tBodyAcc-XYZ described below.
* BodyAcc.mean/std.XYZ - From mean/std of tGravityAcc-XYZ described below.
* BodyAccJerk.mean/std.XYZ - From mean/std of tBodyAccJerk-XYZ described below.
* BodyGyro.mean/std.XYZ - From mean/std of tBodyGyro-XYZ described below.
* BodyGyroJerk.mean/std.XYZ - From mean/std of tBodyGyroJerk-XYZ described below.
* BodyAccMag.mean/std - From mean/std of tBodyAccMag described below.
* GravityAccMag.mean/std - From mean/std of tGravityAccMag described below.
* BodyAccJerkMag.mean/std - From mean/std of tBodyAccJerkMag described below.
* BodyGyroMag.mean/std - From mean/std of tBodyGyroMag described below.
* BodyGyroJerkMag.mean/std - From mean/std of tBodyGyroJerkMag described below.
* BodyAcc.mean/std.XYZ - From mean/std of fBodyAcc-XYZ described below.
* BodyAccJerk.mean/std.XYZ - From mean/std of fBodyAccJerk-XYZ described below.
* BodyGyro.mean/std.XYZ - From mean/std of fBodyGyro-XYZ described below.
* BodyAccMag.mean/std - From mean/std of fBodyAccMag described below.
* BodyAccJerkMag.mean/std - From mean/std of fBodyAccJerkMag described below.
* BodyGyroMag.mean/std - From mean/std of fBodyGyroMag described below.
* BodyGyroJerkMag.mean/std - From mean/std of fBodyGyroJerkMag described below.

## Data
Data was housed in two folders inside the "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset" directory. The "train" folder contains the training data, while the "test" folder contains the test data. The applicable files (listed below) were read and the resulting data frames concatenated.

Subject data was collected from "train/subject_train.txt" and "train/subject_test.txt" formatted as a single column table with each observance's subject index. Activity data was collected from "train/y_train.txt" and "text/y_test.txt" as a single column table with each observance's activity index. The measurements were found in "train/X_train.txt" and "test/X_test.txt" as a 561 column table with a row per observance.

The format of the measurements table is described below.

From "features_info.txt"
> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

> Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

> Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

> These signals were used to estimate variables of the feature vector for each pattern: '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

> * tBodyAcc-XYZ
> * tGravityAcc-XYZ
> * tBodyAccJerk-XYZ
> * tBodyGyro-XYZ
> * tBodyGyroJerk-XYZ
> * tBodyAccMag
> * tGravityAccMag
> * tBodyAccJerkMag
> * tBodyGyroMag
> * tBodyGyroJerkMag
> * fBodyAcc-XYZ
> * fBodyAccJerk-XYZ
> * fBodyGyro-XYZ
> * fBodyAccMag
> * fBodyAccJerkMag
> * fBodyGyroMag
> * fBodyGyroJerkMag

> The set of variables that were estimated from these signals are: 

> * mean(): Mean value
> * std(): Standard deviation

## Transformations
Data from the 6 files were read from files into tables.

    width.read <- c(-1, 15)
    data.measurements.train <- read.fwf("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", widths=rep(width.read, 561))
    data.activity.train <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
    data.subject.train <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
    data.measurements.test <- read.fwf("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", widths=rep(width.read, 561))
    data.activity.test <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
    data.subject.test <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

Data were concatenated by column to combine subject, activity, and measurements into a single table.

    data.merged.train <- cbind(data.subject.train, data.activity.train, data.measurements.train)
    data.merged.test <- cbind(data.subject.test, data.activity.test, data.measurements.test)

Data were concatenated by row to combine training and test measurements into a single table.

    data.merged <- rbind(data.merged.train, data.merged.test)

The measurement data was trimmed to include only the mean and standard deviation calculations.

    features <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", sep=" ", col.names=c("col", "measurement"))
    features.vector.trim <- c(TRUE, TRUE, grepl("mean[(][)]", features$measurement)|grepl("std[(][)]", features$measurement))
    data.trim <- data.merged[features.vector.trim]

Column labels were applied to improve readability.

    features.label <- c("Subject", "Activity", as.character(features$measurement))[features.vector.trim]
    features.label <- gsub("^t", "", features.label)
    features.label <- gsub("^f", "", features.label)
    features.label <- gsub("[()][)]", "", features.label)
    features.label <- gsub("-", ".", features.label)
    data.descriptive <- data.trim
    names(data.descriptive) <- features.label

Activities were labeled as a factor to provide descriptive names.

    label.activity <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", sep=" ", col.names=c("factor", "activity"))
    data.descriptive$Activity <- factor(data.descriptive$Activity, labels=as.character(label.activity$activity))

Data were written out to "tidy_data.txt" to provide a second, independent tidy data set.

    write.table(data.tidy, file="tidy_data.txt", sep="\t")