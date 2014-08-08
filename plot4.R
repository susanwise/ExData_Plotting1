## exploring data - project 1 - plot4

##one time activity to pull data to hard drive
https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## set the directory to data to unload the file
setwd("./data")
temp <- tempfile()
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,temp)

unzip(temp, files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)
unlink(temp)



##start here and set the path to where you put the data
## establish path where the Udata is located
path <- "C:/Users/Owner/Documents/data"
setwd(path)
library(datasets)
library(data.table)
library(sqldf) 
fname <- "household_power_consumption.txt"

#define special class for the input date format
setClass('myDate')
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
# define myfile as a file with indicated format 
myfile <- file(fname)  
classes <- c("myDate", "character", "numeric", "numeric",
             "numeric", "numeric", "numeric", "numeric", "numeric")
attr(myfile, "file.format") <- list(sep = ";",  header = TRUE,
                                    colClasses = classes) 

# use sqldf to read it limiting to 2007 data
myfile.df <- sqldf("select * from myfile 
                   where Date in( '1/2/2007', '2/2/2007') ") 
# fix up type of Date and Time
myfile.df$Date <- as.Date(myfile.df$Date, format="%d/%m/%Y")
##this creates timestamp in posixlt class to use for plotting
myfile.df$tstamp <- (strptime
                     (paste(myfile.df$Date, myfile.df$Time),
                      format="%F %T"))  
##plot4 - create and copy to png file
par(mfcol = c(2,2), mar = c(4, 4, 4, 2), oma = c(1, 1, 0, 0)) 
with(myfile.df, 
{    
        plot(tstamp, Global_active_power,type="l", 
             ylab = "Global Active Power", xlab="")    
        
        plot(tstamp, Sub_metering_1, type="l", lwd=1,
             ylab = "Energy Sub Metering", xlab="")
        points(tstamp, Sub_metering_2, type="l", lwd=1,col = "red")
        points(tstamp, Sub_metering_3, type="l", lwd=1,col = "blue")
        legend("topright",  lwd=c(2,2,2), col = c("black", "blue", "red"), 
               legend = c("Sub_metering_1", "Sub_metering_2", 
                          "Sub_metering_3"), bty="n")
        
        plot(tstamp, Voltage, type="l", xlab="datetime" )
        
        plot(tstamp, myfile.df$Global_reactive_power, type="l",
             ylab="Global_reactive_power",
             xlab="datetime")
        
})
dev.copy(png, file="plot4.png")
dev.off()