#Merges the testing and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Set directory
setwd("~/Documentos/datasciencespecialization/exploringdata/uci")

#load dplyr
library(dplyr)

##Extract features
features_labels <- read.table("features.txt")[,2]

##Extract labels of both (test and train)
activity_labels <- read.table("activity_labels.txt")[,2]

##extract the measurement of features
extract_features <- grepl("mean|std", features_labels)

##Extract test data
df.test.y <- read.table("./test/y_test.txt")
df.test.x <- read.table("./test/X_test.txt")
names(df.test.x) <- features_labels
subject_test <- read.table("./test/subject_test.txt")

# Extract only the measurements on the mean and standard deviation for each measurement.
df.test.x = df.test.x[,extract_features]

# Load activity labels
df.test.y[,2] = activity_labels[df.test.y[,1]]
names(df.test.y) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

##Bind test data
test_data <- cbind(as.data.table(subject_test), df.test.y, df.test.x)

##Extract train data
df.train.y <- read.table("./train/y_train.txt")
df.train.x <- read.table("./train/X_train.txt")
names(df.train.x) <- features_labels
subject_train <- read.table("./train/subject_train.txt")

# Extract only the measurements on the mean and standard deviation for each measurement.
df.train.x <- df.train.x[,extract_features]

# Load activity labels 
df.train.y[,2] = activity_labels[df.train.y[,1]]
names(df.train.y) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

##Bind train data
train_data <- cbind(as.data.table(subject_train), df.train.y, df.train.x)

##merge data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")