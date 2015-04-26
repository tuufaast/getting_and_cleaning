##change this to your directory having the data and code
setwd("C:/Users/Kipa/Desktop/kurssit/getting_and_cleaning")

#load in features and labels
features=read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
labels = read.table("UCI HAR Dataset//activity_labels.txt",stringsAsFactors=FALSE)

#load in test data
test_X=read.table("UCI HAR Dataset//test/X_test.txt")
test_Y=read.table("UCI HAR Dataset//test/y_test.txt")
test_subject=read.table("UCI HAR Dataset//test/subject_test.txt")

#combine test data
test_set_total=cbind(test_X,test_Y, test_subject)

#load in training data
train_X=read.table("UCI HAR Dataset//train/X_train.txt")
train_Y=read.table("UCI HAR Dataset//train/y_train.txt")
train_subject=read.table("UCI HAR Dataset//train/subject_train.txt")

#combine training data
train_set_total=cbind(train_X,train_Y, train_subject)

#label in which set each row belongs
train_set_total$group="train"
test_set_total$group="test"

#combine datas and name the variables

data1 = rbind(train_set_total, test_set_total)
colnames(data1)=c(features[,2],"Y", "subject", "group")

#get only those columns that have mean or std

#obs! only the ones with mean() or std() are got, as this was said to be ok 
#in the course discussions
t=grep("mean\\(\\)|std\\(\\)", colnames(data1))

#get right data + activity (Y) + subject
data=data1[,c(t,1:2+length(features[,1]))]

library(plyr)
data=rename(data,c("Y"="activity"))

#add activities with their correct labels
data$activity=as.factor(data$activity)
data$activity=mapvalues(data$activity, from = labels[,1], to = labels[,2])

#calculate means for each feature per activity and subject
helpMatrix=data %>% 
  group_by(activity,subject) %>% 
  summarise_each(funs(mean))


#create a data frame
tidydata=as.data.frame(helpMatrix)
