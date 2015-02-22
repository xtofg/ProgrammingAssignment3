setwd("~/Documents/Coursera/3 - Getting and cleaning data/Assignment")

# Load the data sets, if not already done
if(!exists("data_train"))
{
  data_train <- read.fwf("UCI HAR Dataset/train/X_train.txt",widths=rep(16,561),buffersize=200)
}

if(!exists("data_test"))
{
  data_test <- read.fwf("UCI HAR Dataset/test/X_test.txt",widths=rep(16,561),buffersize=200)
}

# Merging
data <- rbind(data_train,data_test)


# Getting the names
features <- read.table("UCI HAR Dataset/features.txt",col.names=c("number","name"))
names(data) <- features$name

# Selection of mean and std columns
sel <- grepl("mean()",names(data),fixed=TRUE) | grepl("std",names(data)) # beware of meanFreq: mean must be followed by a parenthesis
data <- data[,sel]

# Getting the activities
activities_train <- read.table("UCI HAR Dataset/train/y_train.txt",col.names="activity")
activities_test <- read.table("UCI HAR Dataset/test/y_test.txt",col.names="activity")
activities <- rbind(activities_train,activities_test)$activity

activities_name <- read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("number","name"))

activities <- factor(activities,levels=1:6,labels=activities_name$name)

data$activity <- activities

# Getting the subjects
subject_train  <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names="subject")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names="subject")
data$subject <- rbind(subject_train,subject_test)$subject

# Computing the means
library(dplyr)
grp=list(data$activity,data$subject) # variables to group by
data <- select(data,c(-activity,-subject)) # variables to be grouped
s <- split(data,grp)
results <- sapply(s,colMeans)

write.table(results,"results.txt",row.names=FALSE)
