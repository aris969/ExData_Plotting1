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

##Plot 4
png(file="plot4.png",width=480,height=480)
par(mfrow=c(2,2))
##1
plot(df1$DateTime, df1$Global_active_power, ylab="Global Active Power", xlab = "", type="l")
##2
plot(df1$DateTime, df1$Voltage, ylab="Voltage", xlab = "datetime", type="l")
##3
line.colors <- c("black", "red", "blue")
plot(df1$DateTime, df1$Sub_metering_1, col=line.colors[1], ylab="Energy sub metering", xlab="", type="l")
lines(df1$DateTime, df1$Sub_metering_2, col=line.colors[2], type="l")
lines(df1$DateTime, df1$Sub_metering_3, col=line.colors[3], type="l")
legend(x="topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = line.colors, lty = c(1, 1, 1), lwd = c(1,1,1), cex=.85, bty="n")
#4
plot(df1$DateTime, df1$Global_reactive_power, ylab="Global_reactive_power", xlab = "datetime", type="l")
dev.off()

