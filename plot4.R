#check if data is already in current working directory, if not download and unzip
if (!file.exists("household_power_consumption.txt")){
download.file(zipUrl, destfile="household_power_consumption.zip")
unzip("household_power_consumption.zip")
}

# create list of column names
colNames <- c("dates", "times", "globalActivePower", "globalReactivePower", "voltage", "globalIntensity", "subMetering1", "subMetering2", "subMetering3")

#create list of column classes
colClass <- c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")

#read data from text file
twodays <- read.table("household_power_consumption.txt", header = FALSE, sep=";", na.strings = "?", stringsAsFactors=FALSE, nrows=2880, skip=66637, col.names = colNames, colClasses=colClass)

twodays$datetime <- paste(twodays$dates, twodays$times, sep=" ")
twodays <- twodays[,c(10,3:9)]
twodays$datetime <- strptime(twodays$datetime, "%d/%m/%Y %H:%M:%S")

#create plot and save to .png file
png("plot4.png", width=480, height=480)
par(mfcol=c(2,2))
with(twodays, {
plot(datetime, globalActivePower, pch=20, ylab ="Global Active Power (kilowatts)", xlab="", type="n")
lines(datetime, globalActivePower)
plot(datetime, subMetering1, pch=20, ylab ="Energy sub metering", xlab="", type="n")
lines(datetime, subMetering1, col="black")
lines(datetime, subMetering2, col="orangered")
lines(datetime, subMetering3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), lwd=c(2,2,2), col=c("black", "orangered", "blue"), bty="n")
plot(datetime, voltage, ylab ="Voltage", xlab="datetime", type="n")
lines(datetime, voltage)
plot(datetime, globalReactivePower, ylab ="Global Reactive Power", xlab="datetime", type="n")
lines(datetime, globalReactivePower)})
dev.off()

print("Plot 4 saved to current working directory")