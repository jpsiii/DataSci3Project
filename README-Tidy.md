####
Data Science MOOC
3 - Getting and Cleaning Data
Course Project - Human Activity Cell Phone Tidy Data
Justin Smith
####


Hello, in my "readme" file I am going to describe the files in my repo and what my script does.  I did not fully understand what I am supposed to do with this "readme" nor exactly what to include in the "codebook", so hopefully I am not too far off.  


####
Files included with repo - 
####

1.) 'README.md'

2.) 'run_analysis.R' : This is my R script that results in the tidy data set.  There are no comments in this file, see below for a description

3.) 'CodeBook.md' : Here you can find a list of the variables in the tidy dataset and a description/justification for both the variables I choose to keep and of the transformations I conducted.


####
Scipt + Explanation of each command
####

run_analysis <- function() {

#these are the packages I use
library(plyr)
library(dplyr)

#setting drectory - I didn't include this in the script I uploaded...
setwd("C:\\Users\\User\\Desktop\\Desktop_Folder\\MOOCs\\Data Science - Hopkins\\3 - Getting and Cleaning Data\\Project\\UCI HAR Dataset\\")
getwd()

#Reading in the main X Train/Test files
Train <- read.table("./train/X_train.txt")
Test <- read.table("./test/X_test.txt")

#Reading in the labels for each of the 6 activities.  I will use this data in the next step.
ActivityLabels <- read.table("./activity_labels.txt")

#Reading in the large file of activities and then joining with the above data of activities.  I also provide a proper column names for the activity ID #and Label as it was requested to make proper variable names.
YTrain <- read.table("./train/y_train.txt")
YTrain <- join(YTrain,ActivityLabels)
YTrain <- rename(YTrain, ActivityID=V1, ActivityLabel=V2)
YTest <- read.table("./test/y_test.txt")
YTest <- join(YTest,ActivityLabels)
YTest <- rename(YTest, ActivityID=V1, ActivityLabel=V2)

#Reading in the file with variable names as rows.  I then transpose the variable names because I need it like that later.
varNames <- read.table("./features.txt")
varNames <- t(varNames)

#Reading in the 30 individual subjects and giving it a proper column name.
SubTrain <- read.table("./train/subject_train.txt")
SubTrain <- rename(SubTrain, SubjectID=V1)
SubTest <- read.table("./test/subject_test.txt")
SubTest <- rename(SubTest, SubjectID=V1)

#Changing column names in Train/TEST so I know what they are.  I simply just take the transposed variable name data set and join it as the column names. #This satifies Step 4.
colnames(Train) = varNames[2, ]
colnames(Test) = varNames[2, ]

#Cbinding Train/Test and Y.  This is how I satisfy Step 3, providing activities with proper names.
Train <- cbind(SubTrain, YTrain, Train)
Test <- cbind(SubTest, YTest, Test)

#Rbinding the Test and Train together. This satisfies Step 1.
Overall <- rbind(Train,Test)

#Finding the columns to keep by searching for "mean()" and "std()" using the grep() function.  I also keep the identity columns.  This satisfies Step 2.
strings <- c("SubjectID", "ActivityID", "ActivityLabel", "mean()", "std()")
colNmbrs <- grep(paste(strings, collapse="|"), names(Overall))
Overall <- Overall[,colNmbrs]

#To create the tidy dataset I use the group_by option from dplyr.  I group by Subject and Activity.  I also arrange the data by subject and activity so it look nice.  The end result is a write table.  This satisfies step 5.
Overall <- arrange(Overall, SubjectID, ActivityID)
tidy <- Overall %>% group_by(SubjectID, ActivityLabel) %>% summarise_each(funs(mean), 4:82)
write.table(tidy, "tidy2.txt", row.name=FALSE)

}