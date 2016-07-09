Code Book for Getting & Cleaning Data Assignment


#Variables

The file *TidyFile.csv* contains 15,480 records for 4 variables

subject - a integer number referring to participant in the study
activity - a factor variable with 6 levels referring to 6 different types of physical activity undertaken as part of the the study (see original data)
variable - a factor variable with 86 levels - describes the type of observation (see below for description)	
mean(value) - average of each variable for each activity and each subject based on an extracts of only the measurements on the mean and standard deviation for each measurement
from the original data set.


#Data

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here is the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip



#Transformations

1. Each relevant file is read into a dataframe
2. An identifier is added to both the Training and Test data sets to allow identification later. (In the end this wasn't required.) However I felt that it was good practice
to carry this data as far through the process as possible
3. The "subject" i.e. the identifier for the particpants and the "activity" the identifier for the phyical activity type were added to both the Test and Train data sets as extra columns
4. The two data sets were then mergerd using rbind to create a single dataframe "TotalData". **assumes that all the columns are in the same order**
5. The column names of TotalData are then updated to reflect those provided in the *features.txt* file. However names have to the added for the extra 3 columns ("dataSet","subject","activity") 
that have been added to the Test and Train data
6. Duplicate columns were removed **not sure why there were duplicate columns so some data may have been lost here**
7. Observations for the Mean and Standard deviation were extracted using a non case sensitive search on "mean" OR "std".  **If other descriptors of meand or standard deviation were used then these would not have been picked up**
8. The activity values were transformed from integer values to the text descriptions provided in the *ActivityLabels.txt* file.
9. Based on the descriptions provided in the source data's *feature_info.txt* file the observation names were reformatted to make them more readable. Thi involved exchanging abbreviations for full words.
	*"Mag" to "Magnitude"
	*"Acc" to "Accelerator"
	*prefix "t" to "time"
	*prefix "f" to "frequency"
	*"Gyro" to "Gyroscope"
10. The result data frame was melted based on the id variables "subect" and "activity", this has the effect of transforming the data frame from one with many columns to one with 4 but where
the 3rd is a factor variable descrbing the type of observation.
11. Finally a grouping was applied so that the the data could be summarised and the means calculated.
  
  