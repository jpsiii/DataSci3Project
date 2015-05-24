run_analysis <- function() {

library(plyr)
library(dplyr)

Train <- read.table("./train/X_train.txt")
Test <- read.table("./test/X_test.txt")

ActivityLabels <- read.table("./activity_labels.txt")

YTrain <- read.table("./train/y_train.txt")
YTrain <- join(YTrain,ActivityLabels)
YTrain <- rename(YTrain, ActivityID=V1, ActivityLabel=V2)
YTest <- read.table("./test/y_test.txt")
YTest <- join(YTest,ActivityLabels)
YTest <- rename(YTest, ActivityID=V1, ActivityLabel=V2)

varNames <- read.table("./features.txt")
varNames <- t(varNames)

SubTrain <- read.table("./train/subject_train.txt")
SubTrain <- rename(SubTrain, SubjectID=V1)
SubTest <- read.table("./test/subject_test.txt")
SubTest <- rename(SubTest, SubjectID=V1)

colnames(Train) = varNames[2, ]
colnames(Test) = varNames[2, ]

Train <- cbind(SubTrain, YTrain, Train)
Test <- cbind(SubTest, YTest, Test)

Overall <- rbind(Train,Test)

strings <- c("SubjectID", "ActivityID", "ActivityLabel", "mean()", "std()")
colNmbrs <- grep(paste(strings, collapse="|"), names(Overall))
Overall <- Overall[,colNmbrs]

Overall <- arrange(Overall, SubjectID, ActivityID)
tidy <- Overall %>% group_by(SubjectID, ActivityLabel) %>% summarise_each(funs(mean), 4:82)
write.table(tidy, "tidy.txt", row.name=FALSE)

}