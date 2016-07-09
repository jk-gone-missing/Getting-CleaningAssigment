GCAssigment <- function(){
  

  #Load libraries 
  library(data.table) 
  library(plyr)
  library(dplyr) 
  
  
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
  YTest <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
  XTest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
  SubjectTest <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
  SubjectTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
  YTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
  XTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
    Features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
    unlink(temp) 

  ###1. MERGE DATA###
  
  #Add a an identifier to each data set in case we need to be able to discriminate record sources later
  XTrain<- mutate(XTrain,DataSet="Train")
  XTest<-mutate(XTest,DataSet="Test")
  #Add the Labels for subect and activity
  XTrain<-cbind(XTrain,SubjectTrain, YTrain)
  XTest<-cbind(XTest,SubjectTest, YTest)
  TotalData <- rbind(XTrain, XTest) #Each data set has the same 561+3 variables, append  XTest to XTrain
  
  #Replace column Names with names from Features
  #Create a vector that contains all the names, the oringal 561 from Features + the 3 Extra
  XNames<- Features[2] #Strip out the first column
  ExtraName <- data.frame(c("dataSet","subject","activity")) #Create a data frame of the 3 extra names
  colnames(ExtraName)<- "V2"  #Rename the column so that the rows can be appended
  XNames<- t(rbind(XNames,ExtraName)) #Transpose the vector so that it can be used in the line below
  colnames(TotalData)<- XNames #Set the column names for the data set
  TotalData <- TotalData[ , !duplicated(colnames(TotalData))] #remove duplicates
  
  ###2. EXTRACT THE MEAN AND STD MEASUREMENTS###
  mean_std_positions<- grep("mean|std",names(TotalData), value=FALSE,ignore.case = TRUE) #use grep to find the positions of any 
  #name containing "mean" OR "std"
  ColumnsToSelect <- c(478:480, mean_std_positions) #Inlcude the information on subect, activity and dataset in the extraction
  ExtractMeanStd <- select(TotalData,ColumnsToSelect) 
  
  ###3. Set descriptive activity names###
  ExtractMeanStd$activity <- as.character(ExtractMeanStd$activity) #change to character so that each value can be reset to a character
  ExtractMeanStd$activity[ExtractMeanStd$activity == 1] <- "Walking"
  ExtractMeanStd$activity[ExtractMeanStd$activity == 2] <- "Walking Upstairs"
  ExtractMeanStd$activity[ExtractMeanStd$activity == 3] <- "Walking Downstairs"
  ExtractMeanStd$activity[ExtractMeanStd$activity == 4] <- "Sitting"
  ExtractMeanStd$activity[ExtractMeanStd$activity == 5] <- "Standing"
  ExtractMeanStd$activity[ExtractMeanStd$activity == 6] <- "Laying"
  #NB above - really felt like there should have been a better way of doing this.  
  
  ###4. Rename the variables###
  
  colnames(ExtractMeanStd) <- gsub("Mag", "Magnitude", colnames(ExtractMeanStd))
  colnames(ExtractMeanStd) <- gsub("Acc", "Accelerator", colnames(ExtractMeanStd))
  colnames(ExtractMeanStd) <- gsub("^t", "time", colnames(ExtractMeanStd))
  colnames(ExtractMeanStd) <- gsub("^f", "frequency", colnames(ExtractMeanStd))
  colnames(ExtractMeanStd) <- gsub("Gyro", "Gyroscope", colnames(ExtractMeanStd))
  
  ###5. independent tidy data set with the average of each variable for each activity and each subject###
  Tidy <- melt(ExtractMeanStd,id.vars=c("subject","activity"),measure.vars=colnames(ExtractMeanStd)[-c(1:3)])
  Tidy <- group_by(Tidy,subject,activity,variable)
  Tidy<-dplyr::summarise(Tidy,mean(value))
  
  write.csv(Tidy,file="TidyFile.csv")
  
}