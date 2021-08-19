# Run analysis 

filename <- "data.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

library(dplyr)

# Assigning all data frames
features <- read.table("UCI HAR Dataset/features.txt", 
                       col.names = c("n","functions"))

activities <- read.table("UCI HAR Dataset/activity_labels.txt", 
                         col.names = c("code", "activity"))

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subject")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", 
                     col.names = features$functions)

y_test <- read.table("UCI HAR Dataset/test/y_test.txt", 
                     col.names = "code")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", 
                            col.names = "subject")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", 
                      col.names = features$functions)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt", 
                      col.names = "code")

# Should do the following. 
  # Merges the training and the test sets to create one data set.
  X <- rbind(x_train, x_test)
  Y <- rbind(y_train, y_test)
  Subject <- rbind(subject_train, subject_test)
  mrgData <- cbind(Subject, Y, X)
  
  # Extracts only the measurements on the mean and standard deviation 
    # for each measurement. 
  data1 <- mrgData %>% select(subject, code, contains("mean"), contains("std"))
  
  # Uses descriptive activity names to name the activities in the data set
  data1$code <- activities[data1$code, 2]
  
  # Appropriately labels the data set with descriptive variable names. 
  names(data1)[2] = "activity"
  names(data1) <- gsub("\\.", "", names(data1))
  names(data1)<-gsub("^t", "Time", names(data1))
  names(data1)<-gsub("^f", "Frequency", names(data1))
  names(data1)<-gsub("Acc", "Accelerometer", names(data1))
  names(data1)<-gsub("Gyro", "Gyroscope", names(data1))
  names(data1)<-gsub("BodyBody", "Body", names(data1))
  names(data1)<-gsub("Mag", "Magnitude", names(data1))
  names(data1)<-gsub("tBody", "TimeBody", names(data1))
  names(data1)<-gsub("mean", "Mean", names(data1), ignore.case = TRUE)
  names(data1)<-gsub("std", "StandardDeviation", names(data1), ignore.case = TRUE)
  names(data1)<-gsub("freq", "Frequency", names(data1), ignore.case = TRUE)
  names(data1)<-gsub("angle", "Angle", names(data1))
  names(data1)<-gsub("gravity", "Gravity", names(data1))
  
  # From the data set in step 4, create a second, independent tidy data set
    # with the average of each variable for each activity and each subject.
  data2 <- data1 %>%
    group_by(subject, activity) %>%
    summarise_all(list(mean=mean))

  write.table(data2, "FinalData.txt", row.name=FALSE)
  
# The submitted data set is tidy. 
# The Github repo contains the required scripts.
# GitHub contains a code book that modifies and updates the available 
  # codebooks with the data to indicate all the variables and summaries 
  # calculated, along with units, and any other relevant information.
# The README that explains the analysis files is clear and understandable.
# The work submitted for this project is the work of the student who 
  # submitted it.