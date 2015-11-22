## Manually download zipped file of the dataset and unzip it into a directory (Recommended)
## Set the location of the unzipped file as the working directory


# Extracting necessary column names for the datasets

# extracting activity column names for  test and train labels
activity_label <- read.table("activity_labels.txt")
activity_label <- activity_label[ , 2]
activity_label <- as.character(activity_label)

# extracting column names for test and train sets
features_data <- read.table("features.txt")
features_data2 <- features_data[ , 2]
features_data2 <- as.character(features_data2)
features <- grepl("mean|std", features_data2) #extracting just mean and standard dev part
features_names <- features_data[features,2]

#loading test dataset
test_set <- read.table("./test/X_test.txt")
names(test_set) <- features_data2

#extracting test data with corresponding mean and standard deviation values
test_set <- test_set[ , features_names] 

test_label <- read.table("./test/y_test.txt")
names(test_label) <- "activity_type"
test_participant <- read.table("./test/subject_test.txt")
names(test_participant) <- "participant"

#Merging components of complete test datasets
dataset_test <- cbind(test_participant, test_label, test_set)

#loading test dataset
train_set <- read.table("./train/X_train.txt")
names(train_set) <- features_data2

#extracting test data with corresponding mean and standard deviation values
train_set <- train_set[ , features_names] 

train_label <- read.table("./train/y_train.txt")
names(train_label) <- "activity_type"
train_participant <- read.table("./train/subject_train.txt")
names(train_participant) <- "participant"
dataset_train <- cbind(train_participant, train_label, train_set)

#Merging test and train datasets => dataset_complete
dataset_complete <- rbind(dataset_test, dataset_train)

library(reshape2)
label   <- c("participant", "activity_type")
#data_labels <- setdiff(colnames(dataset_complete), id_labels)

#Removing the "participant" and "activity_type" columns from variables to be analysed
column_names <- colnames(dataset_complete)
b <- column_names %in% label
variable <- column_names[!b]

melt_dataset  <- melt(dataset_complete, id = label, measure.vars = variable)
# Apply mean function to dataset using dcast function
tidy_data   <- dcast(melt_dataset, participant + activity_type ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)