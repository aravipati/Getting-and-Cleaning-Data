library(reshape2)

inputFile <- "C:/Users/Ananya/Downloads/getdata-projectfiles-UCI HAR Dataset.zip"

## unzip the dataset:
 
if (!file.exists("UCI HAR Dataset")) { 
  unzip(inputFile) 
}

# extract activity labels & features 
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
featuresInput <- read.table("UCI HAR Dataset/features.txt")
featuresInput[,2] <- as.character(featuresInput[,2])

# mean and sd by subsetting
std_mean <- grep(".*mean.*|.*std.*", features[,2])
std_mean.names <- features[std_mean,2]
std_mean.names = gsub('-mean', 'Mean', std_mean.names)
std_mean.names = gsub('-std', 'Std', std_mean.names)
std_mean.names <- gsub('[-()]', '', std_mean.names)


# Load test and train datasets

testInput <- read.table("UCI HAR Dataset/test/X_test.txt")[std_mean]
testInput_Activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testInput_Subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testInput <- cbind(testInput_Subjects, testInput_Activities, testInput)

trainInput <- read.table("UCI HAR Dataset/train/X_train.txt")[std_mean]
trainInput_Activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainInput_Subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainInput <- cbind(trainInput_Subjects, trainInput_Activities, trainInput)

# bind test and train data and then add labels
allData <- rbind(trainInput, testInput)
colnames(allData) <- c("subject", "activity", std_mean.names)

# preliminary step to extract tidy data set is to turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "C:/Users/Ananya/Downloads/independent_tidy_data.txt", row.names = FALSE, quote = FALSE)