## Project
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

# 1. Merges the training and the test sets to create one data set.
train <- cbind(X_train, y_train, subject_train)
colnames(train) <- c(features$V2, "y", "subject")
test <- cbind(X_test, y_test, subject_test)
colnames(test) <- c(features$V2, "y", "subject")
data <- rbind(train, test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_or_std <- grep("mean|std", names(data))
data <- data[,c(mean_or_std,ncol(data)-1,ncol(data))]
data$y <- as.factor(data$y)
data$subject <- as.factor(data$subject)

# 3. Uses descriptive activity names to name the activities in the data set: 
# WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
levels(data$y) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

# 4. Appropriately labels the data set with descriptive variable names. 
names(data) <- gsub("[()]", "", names(data))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
data_melt <- melt(data, id=c("y","subject"), measure.vars=names(data)[1:(ncol(data)-2)])
data2 <- dcast(data_melt, y+subject ~ variable, mean)

# Save a tidy table
write.table(data2, "./tidy_data.csv", row.names=FALSE)

