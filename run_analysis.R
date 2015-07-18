
## Using the UCI HAR Datasets unzipped, starting from the original folder this procedure does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# 6. writes the dataset ( 180 rows by 81 cols ) into a file named "GettingCleaningDataProject.txt" and returns it 
# 

Run.Analysis <- function(UCIHARDatasetFolder = ".") {
    library(dplyr)
    BaseFilePath = file.path(UCIHARDatasetFolder ,"UCI HAR Dataset")
    
    ## Read the Test Data
    X_test   <- read.table(file.path(BaseFilePath,"test","X_test.txt"), quote="\"", comment.char="",row.names = NULL)
    
    ## Read the features list and create unique names from it
    features <- read.table(file.path(BaseFilePath,"features.txt"), quote="\"", comment.char="", stringsAsFactors=FALSE)
    features[,2] <- make.names(features[,2],unique = TRUE)
    
    ## Assign the newly created names to the Test dataset
    names(X_test) = features[,2]
    
    ## Read subject and activity and attach two new columns to the Test dataset
    subject <- read.table(file.path(BaseFilePath,"test","subject_test.txt"), quote="\"", comment.char="", stringsAsFactors=FALSE)
    X_test$Subject <- subject[,1]
    activity <- read.table(file.path(BaseFilePath,"test","y_test.txt"), quote="\"", comment.char="", stringsAsFactors=FALSE)
    X_test$Activity <- activity[,1]
    
    ## Read the Train Data
    X_train <- read.table(file.path(BaseFilePath,"train","X_train.txt"), quote="\"", comment.char="", stringsAsFactors=FALSE,row.names = NULL)
    
    ## Assign columns names to the Train dataset
    names(X_train) = features[,2]
    
    ## Read subject and activity and attach two new columns to the Train dataset
    subject <- read.table(file.path(BaseFilePath,"train","subject_train.txt"), quote="\"", comment.char="")
    X_train$Subject <- subject[,1]
    activity = read.table(file.path(BaseFilePath,"train","y_train.txt"), quote="\"", comment.char="")
    X_train$Activity <- activity[,1]

    ## Merge Test and Train
    merged = rbind(X_train,X_test)
    
    # Select only the columns that deal with mean or std or are the Activity,Subject
    merged = merged[,grep("std|mean|Activity|Subject",names(merged))]
    
    # Group by Activity and Subject and summurise calculating the mean for each column
    group_by_activity_subject=group_by(merged,Activity,Subject)
    sum1 = summarise_each(group_by_activity_subject,funs(mean),1:(ncol(group_by_activity_subject)-2) )
    
    # Add descriptive labels to the Activity column using factors
    sum1$Activity = factor(sum2$Activity, labels = c("Walking","Walking_Upstairs","Walking_Downstairs","Sitting","Standing","Laying"))
    
    
    #writes the dataset to a file and returns it
    write.table( sum1,file = "GettingCleaningDataProject.txt" , row.name=FALSE)  
    sum1
}




