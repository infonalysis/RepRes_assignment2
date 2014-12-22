#setwd("~/Documents/School/Coursera/reproducible_research/RepData_PeerAssessment2/RepRes_assignment2")
setwd("C:\\Users\\rupert\\Documents\\GitHub\\RepRes_assignment2")

library("data.table")

#
#  read in and clean data
#

# read in full csv
data_orig <- read.table("repdata_data_StormData.csv.bz2", header=T, sep = ",", stringsAsFactors=F)


# set allowed values for EVTYPE
allowed_evtypes <- as.factor(c("astronomical low tide", "avalanche", "blizzard", "coastal flood", "cold/wind chill", "debris flow", "dense fog", "dense smoke", "drought", "dust devil", "dust storm", "excessive heat", "extreme cold/wind chill", "flash flood", "flood", "frost/freeze", "funnel cloud", "freezing fog", "hail", "heat", "heavy rain", "heavy snow", "high surf", "high wind", "hurricane (typhoon)", "ice storm", "lake-effect snow", "lakeshore flood", "lightning", "marine hail", "marine high wind", "marine strong wind", "marine thunderstorm wind", "rip current", "seiche", "sleet", "storm surge/tide", "strong wind", "thunderstorm wind", "tornado", "tropical depression", "tropical storm", "tsunami", "volcanic ash", "waterspout", "wildfire", "winter storm", "winter weather"))

# keep track of data we're throwing out due to bad evtype
data_bad_ev <- data_orig[!(tolower(data_orig$EVTYPE) %in% allowed_evtypes),]

# weed out data with bad evtype
data_good_ev <- data_orig[(tolower(data_orig$EVTYPE) %in% allowed_evtypes),]

# convert good evtype data to lower case and change type to factor
data_good_ev$EVTYPE <- as.factor(tolower(data_good_ev$EVTYPE))





#
# 1. Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?
#

#calculate fatalities by evtype
fatal_by_ev <- tapply(data_good_ev[!is.na(data_good_ev$FATALITIES),]$FATALITIES, data_good_ev[!is.na(data_good_ev$FATALITIES),]$EVTYPE, sum)

#calculate injuries by evtype
injury_by_ev <- tapply(data_good_ev[!is.na(data_good_ev$INJURIES),]$INJURIES, data_good_ev[!is.na(data_good_ev$INJURIES),]$EVTYPE, sum)

# merge these tables & graph
health_risks <- rbind(t(fatal_by_ev), t(injury_by_ev))
par(las=2)
barplot(health_risks, main="Injuries and Fatalities by Weather Event", xlab="Number of Health Impacts", col=c("darkblue","red"), legend = rownames(health_risks), horiz=T, cex.names=0.8)


#
# 2. Across the United States, which types of events have the greatest economic consequences?
#

# need to use PROPDMG and CROPDMG
# (PROP|CROP)DMGEXP contains multiplier
# Multiplier Key: "K" for thousands, "M" for millions, and "B" for billions
# fix up these fields to contain helpful values

multiplier <- c(1000,1000000,1000000000)

data_good_ev$PROPDMG <- data_good_ev$PROPDMG* multiplier[match(data_good_ev$PROPDMGEXP, c("K","M","B"))]
data_good_ev$CROPDMG <- data_good_ev$PROPDMG* multiplier[match(data_good_ev$CROPDMGEXP, c("K","M","B"))]









## Maybe cool stuff that doesn't work
#  data_orig <- fread("repdata_data_StormData.csv", header=TRUE, sep = ",", stringsAsFactors=FALSE)

# allowed values for EVTYPE
allowed_evtypes <- ["Astronomical Low Tide", "Avalanche", "Blizzard", "Coastal Flood", "Cold/Wind Chill", "Debris Flow", "Dense Fog", "Dense Smoke", "Drought", "Dust Devil", "Dust Storm", "Excessive Heat", "Extreme Cold/Wind Chill", "Flash Flood", "Flood", "Frost/Freeze", "Funnel Cloud", "Freezing Fog", "Hail", "Heat", "Heavy Rain", "Heavy Snow", "High Surf", "High Wind", "Hurricane (Typhoon)", "Ice Storm", "Lake-Effect Snow", "Lakeshore Flood", "Lightning", "Marine Hail", "Marine High Wind", "Marine Strong Wind", "Marine Thunderstorm Wind", "Rip Current", "Seiche", "Sleet", "Storm Surge/Tide", "Strong Wind", "Thunderstorm Wind", "Tornado", "Tropical Depression", "Tropical Storm", "Tsunami", "Volcanic Ash", "Waterspout", "Wildfire", "Winter Storm", "Winter Weather"]