# Installs and loads the necessary packages
install.packages(plyr)
library(plyr)

# Define variables to be used in code.
# Your Facebook name:
username <- "Henry Shackleton"
# The number of seconds elapsed to warrent a "new" conversation.
# 86400 = one day.
# The lower you make this number, the more your data will just look like
# the frequency that you send messages.
new.convo.seconds <- 86400
# The minimum number of messages for someone to be counted as a relevant datapoint.
minimum.messages <- 50


# Reads in messenger data and removes empty messages (created whenever a conversation is initialized apparently) and threads with commas in the titles (meant as a rough but imperfect attempt to filter out group chats - you can manually remove other groups if you care).
messenger.data <- read.csv(file="outputFull.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)
messenger.data <- messenger.data[!(is.na(messenger.data$message) | messenger.data$message=="" | grepl(",", messenger.data$thread)),]

# Parses time data into a usable format.
messenger.data$parsed.time <- strptime(messenger.data[,3], "%Y-%m-%dT%H:%M-%S:00")

# Splits data into a list corresponding to each messaging thread.
split.data <- split(messenger.data, messenger.data$thread)

# Defines function to take in dataframe corresponding to a thread 
# and output frequency in which you start a conversation.
percent.me <- function(X) {

  # Creates a data column corresponding to the time difference between each message and the previous message.
  # The first message is automatically assigned the value of new.convo.seconds, so that it's designated as a conversation starter.
  X$time.diff <- c(new.convo.seconds, diff(X$parsed.time))

  # Creates new vector only containing messages that started a conversation.
  modX <- X[!(X$time.diff < new.convo.seconds), ]

  # Counts the number of times each person started a message.
  counted.data <- count(modX, vars= "sender")
  
  # Outputs the frequency that you started a message.
  counted.data[counted.data$sender == username ,"freq"]/sum(counted.data[,2])
}

# Filters out conversations whose number of messages are below the designated amount.
fake.friends <- names(which(lapply(split.data, nrow) < minimum.messages))
full.data <- lapply(split.data, percent.me)
full.data <- ldply (full.data, data.frame)
full.data <- full.data[!(full.data$.id %in% fake.friends),]

# Creates histogram corresponding to the data obtained.
png('convo_distribution_people.png')
hist(full.data[,2], breaks=seq(0, 1, by=1/12), main="Personal Tendency to Start Conversations", col="blue", xlab="Frequency of Conversation Starting", ylab="Number of Conversations")
dev.off()

# Outputs a .csv file giving the individual names of people and conversation starting frequency
write.csv(full.data, "convo_data.csv", row.names=FALSE)
