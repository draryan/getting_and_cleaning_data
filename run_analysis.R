###Data download
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "wee4.zip", method="curl")
##unzip and save files in the "final" folder
if(!file.exists("final")) {
  unzip("week4.zip", exdir="./final")
}

####convert txt files into dataframes

features <- read.table("final/UCI HAR Dataset/features.txt", col.names = c("n","f_variables"))
activities <- read.table("final/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("final/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("final/UCI HAR Dataset/test/X_test.txt")
names(x_test)<-features$f_variables
y_test <- read.table("final/UCI HAR Dataset/test/y_test.txt", col.names = "activity_code")
subject_train <- read.table("final/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("final/UCI HAR Dataset/train/X_train.txt")
names(x_train)<-features$f_variables
y_train <- read.table("final/UCI HAR Dataset/train/y_train.txt", col.names = "activity_code")

#1. Merges the training and the test sets to create one data set
x_set<-rbind(x_train, x_test)
y_set<-rbind(y_train, y_test)
subject<-rbind(subject_train, subject_test)
merge_data<-cbind(subject, y_set, x_set)
View(merge_data)

#2. Extracts only the measurements on the mean and standard deviation for each measurement
dataset<-merge_data[,grep("subject|activity_code|mean|Mean|std",names(merge_data))]
View(dataset)

#3. Uses descriptive activity names to name the activities in the data set
dataset$activity_code<-activities[dataset$activity_code,2]

#4. Appropriately labels the data set with descriptive variable names
###view current variable names
names(dataset)
###change names
names(dataset)<-gsub("Acc", "accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "gyroscope", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))
names(dataset)<-gsub("Mag", "magnitude", names(dataset))
names(dataset)<-gsub("^t", "time", names(dataset))
names(dataset)<-gsub("^f", "frequency", names(dataset))
names(dataset)


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydata<-dataset%>%
          group_by(subject, activity_code)%>%
          summarise_each(list(mean = mean))
write.table(tidydata, file = "final/UCI HAR Dataset/tidydata.txt", row.names = FALSE)
