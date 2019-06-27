#0. importing library
library(reshape2)
#1. Downloading the data to the target path
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest_f <- "UCI HAR Dataset.zip"
dest_p <- "UCI HAR Dataset"

if(!file.exists(dest_f)){download.file(fileURL,dest_f, mode = "wb") }

if (!file.exists(dest_p)) {unzip(dest_f)}

#2. a) Using the features and labels as the filters to select
#   b) selecting data

'A.Creating Filter by labels and features'
##activity labels
activities <- read.table(file.path(dest_p, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

## features
features <- read.table(file.path(dest_p, "features.txt"), as.is = TRUE)

# Extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

## training data-filtered
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainingSubjects <- read.table(file.path(dest_p, "train", "subject_train.txt"))
trainingValue <- read.table(file.path(dest_p, "train", "X_train.txt"))
trainingActivities <- read.table(file.path(dest_p, "train", "y_train.txt"))
train <- cbind(trainingSubjects, trainingActivities, train)

## test data - filtered
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testSubjects <- read.table(file.path(dest_p, "test", "subject_test.txt"))
testValue <- read.table(file.path(dest_p, "test", "X_test.txt"))
testActivities <- read.table(file.path(dest_p, "test", "y_test.txt"))
test <- cbind(testSubjects, testActivities, test)

#3. Merging Data
data_1 <- rbind(train,test)
colnames(data_1) <- c("subject","activity",featuresWanted.names)

#4. labeling
data_1$activity <- factor(data_1$activity, levels = activityLabels[,1], labels = activityLabels[,2])
data_1$subject <- as.factor(data_1$subject)

data_1.melted <- melt(data_1, id = c("subject", "activity"))
data_1.mean <- dcast(data_1.melted, subject + activity ~ variable, mean)

#5.Recreate the tidy data
write.table(data_1.mean, "Tidy_RY_062719.txt", row.names = FALSE, quote = FALSE)





                       