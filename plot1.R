#
# read header and first row of data file
#
labels<-read.table("household_power_consumption.txt", header=TRUE, sep=";", dec=".", na.strings = "?", nrows=1, stringsAsFactors=FALSE)
#
# in first row, get date and time information 
# put them together in a date_time variable called moment0
#
day0<-as.Date(labels[1,1],"%d/%m/%Y")
c0<-paste(day0,labels[1,2])
moment0<-strptime(c0,"%Y-%m-%d %H:%M:%S")
#
# specify initial date to plot (day1)
# find initial moment, considering 00:00:00 the initial time
# define moment1 like a date_time variable: day1 + "00:00:00"
#
day1<-as.Date("2007-02-01","%Y-%m-%d")
c1<-paste(day1,"00:00:00")
moment1<-strptime(c1,"%Y-%m-%d %H:%M:%S")
#
# specify final date to plot (day2)
# find final moment, considering 23:59:00 the last time
# define moment2 like a date_time variable: day2 + "23:59:00"
#
day2<-as.Date("2007-02-02","%Y-%m-%d")
c2<-paste(day2,"23:59:00")
moment2<-strptime(c2,"%Y-%m-%d %H:%M:%S")
#
# calculate skip (the number of lines of the data file to skip before beginning to read data)
# skip = moment1 - moment0 + 1 (in minutes, because we have a table with data in one-minute sampling rate)
# calculate nrows (the number of rows to read in)
# nrows = moment2 - moment1 + 1 (in minutes)
#
skip<-difftime(moment1,moment0, units="mins")+1
nrows<-difftime(moment2,moment1, units="mins")+1
#
# read the data from just those requiring dates
#
table<-read.table("household_power_consumption.txt", header=FALSE, sep=";", dec=".", na.strings = "?", nrows=nrows, skip=skip, stringsAsFactors=FALSE)
#
# put label names to columns
#
names(table)<-names(labels)
#
# create a new column with date_time information
# remember that in original data date is the first column and time is the second 
#
table[,1]<-as.Date(table[,1],"%d/%m/%Y")
c<-paste(table[,1],table[,2])
d<-strptime(c,"%Y-%m-%d %H:%M:%S")
table<-cbind(Date_Time=d,table)
#
# construct the histogram with data in Global_active_power column (now is 4th column)
#
hist(table[,4], main="Global Active Power", xlab="Global Active Power (kilowatts)", col="red")
#
# copy the plot to a PNG file (width of 480 pixels and height of 480 pixels)
# close the PNG device!
#
dev.copy(png, file = "plot1.png", width = 480, height = 480, units = "px")
dev.off()