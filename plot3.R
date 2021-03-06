
library(dplyr)
library(lubridate)

##Look if File already exists
if (file.exists("household_power_consumption.txt")==FALSE) {
  ##If not then download file
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp, mode="wb")
  unzip(temp, "household_power_consumption.txt")
  unlink(temp)
}


##Determine column classes and import data file.
df.sample <- read.table("household_power_consumption.txt", header=TRUE, sep=";", stringsAsFactors=FALSE, nrows=5)
classes <- sapply(df.sample, class)

df1 <- df.sample <- read.table("household_power_consumption.txt", header=TRUE, sep=";", stringsAsFactors=FALSE, na.strings = "?", colClasses = classes)
##Convert date filed to date type and filter
df1$Date = as.Date(df1$Date, "%d/%m/%Y")
df1 <- df1[which(df1$Date >= "2007-02-01" & df1$Date <= "2007-02-02"), ]
rm(df.sample)

#Create continuous date time field
df1$DateTime <- as.POSIXct(paste(df1$Date, df1$Time), format="%Y-%m-%d %H:%M:%S")

##Plot 3
png(file="plot3.png",width=480,height=480)
line.colors <- c("black", "red", "blue")
plot(df1$DateTime, df1$Sub_metering_1, col=line.colors[1], ylab="Energy sub metering", xlab="", type="l")
lines(df1$DateTime, df1$Sub_metering_2, col=line.colors[2], type="l")
lines(df1$DateTime, df1$Sub_metering_3, col=line.colors[3], type="l")
legend(x="topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = line.colors, lty = c(1, 1, 1), lwd = c(1,1,1))
dev.off()