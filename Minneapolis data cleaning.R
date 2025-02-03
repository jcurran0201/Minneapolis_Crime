library(dplyr) 
library(tidyr) 
library(tidyverse) 
library(ggplot2)
library(forcats)
library(broom)  
library(lubridate)
crimes_clean_data <- crimes[ -c(2:3,5,14:15, 17:20) ] %>% na.omit()  
datetime <- ymd_hms(crimes_clean_data$BeginDate) 
year <- year(datetime)
month <- month(datetime)  
#add year and month to the crimes_clean_data and then drop NA 
crimes_clean_data <- cbind(crimes_clean_data,year,month) %>% na.omit()   
view(crimes_clean_data)   
#What times of the day have the most crime by hour? Bin the Time by hour.  
#Does Time have correlation with certain crimes?  
# Parse times
crimes_clean_data$Time <- hms::as_hms(crimes_clean_data$Time) 
crimes_clean_data$Time <- hour(crimes_clean_data$Time) + minute(crimes_clean_data$Time) / 60
new_df <- cbind(crimes_clean_data,E=crimes_clean_data$Time)  
new_df <- new_df[ -c(14) ]  
#Bin the data bi-hourly in range 0-24
binned_time <- cut(new_df$Time,breaks = 12)  
new_df <- cbind(crimes_clean_data,x=binned_time)  
new_df <- new_df %>%
  rename(Binned_time = x)   
#view(new_df)
#Breaking things down by year (precint and violent and non violent crimes)
# Filter for 2013
crimes_2013 <- crimes1 %>%
  filter(Year == "2013") %>%
  select(-c(2:3, 5, 7, 14:15, 17:20))
# Check for 'Time' column existence
if (!"Time" %in% colnames(crimes_2013)) {
  # If 'Time' is missing, extract from 'BeginDate'
  crimes_2013 <- crimes_2013 %>%
    mutate(Time = format(as.POSIXct(BeginDate), "%H:%M:%S"))
}
# Parse `Time` and convert to decimal hours
crimes_2013 <- crimes_2013 %>%
  mutate(Time = hms::as_hms(Time),
         Time = hour(Time) + minute(Time) / 60)
# Drop NA
crimes_clean_data <- crimes_2013 %>%
  na.omit()
# Add new column
new_df <- crimes_2013 %>%
  mutate(E = Time)
# View the data
#View(crimes_2013)
#Bin the data bi-hourly in range 0-24
binned_time <- cut(crimes_2013$Time,breaks = 12)  
crimes_2013 <- cbind(crimes_2013,x=binned_time)  
crimes_2013 <- crimes_2013 %>%
  rename(Binned_time = x)   
### 2016 data only goes up to July 1, 2016 Add Time and Binned time
crimes1 <- crimes %>%
  mutate(BeginDate = as.POSIXct(BeginDate, format = "%Y-%m-%d %H:%M:%S"))
filtered_data1 <- filter(crimes1, between(BeginDate, 
                                          as.POSIXct("2016-01-01 00:00:00"), 
                                          as.POSIXct("2016-12-31 11:59:59")))
crimes1 <- crimes1 %>%
  mutate(BeginDate = as.POSIXct(BeginDate, format = "%Y-%m-%d %H:%M:%S"))
# Create new columns for month and year
crimes1 <- crimes1 %>%
  mutate(Year = format(BeginDate, "%Y"),
         Month = format(BeginDate, "%m"))
# Filter for rows where the year equals 2016
crimes_2016 <- crimes1 %>%
  filter(Year == "2016")
crimes_2016 <- crimes_2016[ -c(2:3,5,7,14:15, 17:20) ] 
# Check for 'Time' column existence
if (!"Time" %in% colnames(crimes_2016)) {
  # If 'Time' is missing, extract from 'BeginDate'
  crimes_2016 <- crimes_2016 %>%
    mutate(Time = format(as.POSIXct(BeginDate), "%H:%M:%S"))
}
# Parse `Time` and convert to decimal hours
crimes_2016 <- crimes_2016 %>%
  mutate(Time = hms::as_hms(Time),
         Time = hour(Time) + minute(Time) / 60)
# Drop NA
crimes_clean_data <- crimes_2016 %>%
  na.omit()
# Add new column
new_df <- crimes_2016 %>%
  mutate(E = Time)
# View the data

#Bin the data bi-hourly in range 0-24
binned_time <- cut(crimes_2016$Time,breaks = 12)  
crimes_2016 <- cbind(crimes_2016,x=binned_time)  
crimes_2016 <- crimes_2016 %>%
  rename(Binned_time = x)    
View(crimes_2016)
#combine individual years from 2010-2016 We have 130,039 crimes accounted for during that time. 
#Remaining data cleaning was done in Excel
library(writexl) 
#write_xlsx(twenty_ten_data, "twenty_ten_data.xlsx") #write_xlsx(twenty_eleven_data, "twenty_eleven_data.xlsx") 
#write_xlsx(twenty_twelve_data, "twenty_twelve_data.xlsx") #write_xlsx(crimes_2013, "twenty_thirteen_data.xlsx") 
#write_xlsx(twenty_fourteen_data, "twenty_fourteen_data.xlsx") #write_xlsx(twenty_fifteen_data, "twenty_fifteen_data.xlsx") 
#write_xlsx(crimes_2016, "twenty_sixteen_data.xlsx")  
Cleaned_data <- Cleaned_data %>% distinct()
view(Cleaned_data)
violent_cleaned<- filter(Cleaned_data,Description == 'Crim Sex Cond-rape'|
                                        Description =="Domestic Assault/Strangulation"|Description=="Robbery Of Person"|
                                        Description == "Aslt-police/emerg P"|Description =="Asslt W/dngrs Weapon"|
                                        Description =="Robbery Per Agg"|Description=="Arson"|Description=="Aslt-great Bodily Hm"|
                                        Description == "2nd Deg Domes Aslt"|Description=="Murder (general)"|
                                        Description == "3rd Deg Domes Aslt"|Description=="1st Deg Domes Asslt"|
                                        Description =="Adulteration/poison"|
                           Description =="Looting"|Description=="Disarm a Police Officer"|Description=="Theft From Person") 
view(violent_cleaned)
#Breaking things down by year (precint and violent and non violent crimes)
twenty_ten_data <- filter(Cleaned_data,year==2010)   
crime_rate_2010 <-( 19364/383078)*100000 #(Crimes recorded/population)*100K Population via Google
precinct3_2010 <- filter(Cleaned_data,Precinct==3&year==2010)  
precinct4_2010 <- filter(Cleaned_data,Precinct==4&year==2010)  
precinct2_2010 <- filter(Cleaned_data,Precinct==2&year==2010)  
precinct1_2010 <- filter(Cleaned_data,Precinct==1&year==2010)  
precinct5_2010 <- filter(Cleaned_data,Precinct==5&year==2010)  
precinct18_2010 <- filter(Cleaned_data,Precinct==18&year==2010) 
violent_crime_twenty_ten <- filter(twenty_ten_data,Description == 'Crim Sex Cond-rape'|
                                     Description =="Domestic Assault/Strangulation"|Description=="Robbery Of Person"|
                                     Description == "Aslt-police/emerg P"|Description =="Asslt W/dngrs Weapon"|
                                     Description =="Robbery Per Agg"|Description=="Arson"|Description=="Aslt-great Bodily Hm"|
                                     Description == "2nd Deg Domes Aslt"|Description=="Murder (general)"|
                                     Description == "3rd Deg Domes Aslt"|Description=="1st Deg Domes Asslt"|
                                     Description =="Adulteration/poison"|Description =="Looting"|Description=="Disarm a Police Officer" 
                                   |Description=="Theft From Person")  
twenty_eleven_data <-  filter(Cleaned_data,year==2011)    
crime_rate_2011 <-( 20648/388096)*100000 #(Crimes recorded/population)*100K Population via Google
precinct3_2011 <- filter(Cleaned_data,Precinct==3&year==2011)  
precinct4_2011 <- filter(Cleaned_data,Precinct==4&year==2011)  
precinct2_2011 <- filter(Cleaned_data,Precinct==2&year==2011)  
precinct1_2011 <- filter(Cleaned_data,Precinct==1&year==2011)  
precinct5_2011 <- filter(Cleaned_data,Precinct==5&year==2011)  
precinct18_2011 <- filter(Cleaned_data,Precinct==18&year==2011) 
violent_crime_twenty_eleven <- filter(twenty_eleven_data,Description == 'Crim Sex Cond-rape'|
                                        Description =="Domestic Assault/Strangulation"|Description=="Robbery Of Person"|
                                        Description == "Aslt-police/emerg P"|Description =="Asslt W/dngrs Weapon"|
                                        Description =="Robbery Per Agg"|Description=="Arson"|Description=="Aslt-great Bodily Hm"|
                                        Description == "2nd Deg Domes Aslt"|Description=="Murder (general)"|
                                        Description == "3rd Deg Domes Aslt"|Description=="1st Deg Domes Asslt"|
                                        Description =="Adulteration/poison"|Description =="Looting"|Description=="Disarm a Police Officer" 
                                      |Description=="Theft From Person")  
twenty_twelve_data <-  filter(Cleaned_data,year==2012)    
crime_rate_2012 <-( 20506/392897)*100000 #(Crimes recorded/population)*100K Population via Google
precinct3_2012 <- filter(Cleaned_data,Precinct==3&year==2012)  
precinct4_2012 <- filter(Cleaned_data,Precinct==4&year==2012)  
precinct2_2012 <- filter(Cleaned_data,Precinct==2&year==2012)  
precinct1_2012 <- filter(Cleaned_data,Precinct==1&year==2012)  
precinct5_2012 <- filter(Cleaned_data,Precinct==5&year==2012)  
precinct18_2012 <- filter(Cleaned_data,Precinct==18&year==2012) 
violent_crime_twenty_twelve <- filter(twenty_twelve_data,Description == 'Crim Sex Cond-rape'|
                                        Description =="Domestic Assault/Strangulation"|Description=="Robbery Of Person"|
                                        Description == "Aslt-police/emerg P"|Description =="Asslt W/dngrs Weapon"|
                                        Description =="Robbery Per Agg"|Description=="Arson"|Description=="Aslt-great Bodily Hm"|
                                        Description == "2nd Deg Domes Aslt"|Description=="Murder (general)"|
                                        Description == "3rd Deg Domes Aslt"|Description=="1st Deg Domes Asslt"|
                                        Description =="Adulteration/poison"|Description =="Looting"|Description=="Disarm a Police Officer" 
                                      |Description=="Theft From Person")     
twenty_fourteen_data <-filter(Cleaned_data,year==2014)   
crime_rate_2014 <-( 20306/407206)*100000 #(Crimes recorded/population)*100K Population via Google
precinct3_2014 <- filter(Cleaned_data,Precinct==3&year==2014)  
precinct4_2014 <- filter(Cleaned_data,Precinct==4&year==2014)  
precinct2_2014 <- filter(Cleaned_data,Precinct==2&year==2014)  
precinct1_2014 <- filter(Cleaned_data,Precinct==1&year==2014)  
precinct5_2014 <- filter(Cleaned_data,Precinct==5&year==2014)  
precinct18_2014 <- filter(Cleaned_data,Precinct==18&year==2014) 
violent_crime_twenty_fourteen<- filter(twenty_fourteen_data,Description == 'Crim Sex Cond-rape'|
                                         Description =="Domestic Assault/Strangulation"|Description=="Robbery Of Person"|
                                         Description == "Aslt-police/emerg P"|Description =="Asslt W/dngrs Weapon"|
                                         Description =="Robbery Per Agg"|Description=="Arson"|Description=="Aslt-great Bodily Hm"|
                                         Description == "2nd Deg Domes Aslt"|Description=="Murder (general)"|
                                         Description == "3rd Deg Domes Aslt"|Description=="1st Deg Domes Asslt"|
                                         Description =="Adulteration/poison"|Description =="Looting"|Description=="Disarm a Police Officer" 
                                       |Description=="Theft From Person")  
twenty_fifteen_data <- filter(Cleaned_data,year==2015)    
crime_rate_2015 <-( 18841/411210)*100000 #(Crimes recorded/population)*100K Population via Google
precinct3_2015 <- filter(Cleaned_data,Precinct==3&year==2015)  
precinct4_2015 <- filter(Cleaned_data,Precinct==4&year==2015)  
precinct2_2015 <- filter(Cleaned_data,Precinct==2&year==2015)  
precinct1_2015 <- filter(Cleaned_data,Precinct==1&year==2015)  
precinct5_2015 <- filter(Cleaned_data,Precinct==5&year==2015)  
precinct18_2015 <- filter(Cleaned_data,Precinct==18&year==2015) 
violent_crime_twenty_fifteen <- filter(twenty_fifteen_data,Description == 'Crim Sex Cond-rape'|
                                         Description =="Domestic Assault/Strangulation"|Description=="Robbery Of Person"|
                                         Description == "Aslt-police/emerg P"|Description =="Asslt W/dngrs Weapon"|
                                         Description =="Robbery Per Agg"|Description=="Arson"|Description=="Aslt-great Bodily Hm"|
                                         Description == "2nd Deg Domes Aslt"|Description=="Murder (general)"|
                                         Description == "3rd Deg Domes Aslt"|Description=="1st Deg Domes Asslt"|
                                         Description =="Adulteration/poison"|Description =="Looting"|Description=="Disarm a Police Officer" 
                                       |Description=="Theft From Person")
twenty_thirteen_data <- filter(Cleaned_data,year==2013)    
crime_rate_2013 <-( 21753/400189)*100000 #(Crimes recorded/population)*100K Population via Google
precinct3_2013 <- filter(Cleaned_data,Precinct==3&year==2013)  
precinct4_2013 <- filter(Cleaned_data,Precinct==4&year==2013)  
precinct2_2013 <- filter(Cleaned_data,Precinct==2&year==2013)  
precinct1_2013 <- filter(Cleaned_data,Precinct==1&year==2013)  
precinct5_2013 <- filter(Cleaned_data,Precinct==5&year==2013)  
precinct18_2013 <- filter(Cleaned_data,Precinct==18&year==2013) 
violent_crime_twenty_thirteen <- filter(crimes_2013,Description == 'Crim Sex Cond-rape'|
                                          Description =="Domestic Assault/Strangulation"|Description=="Robbery Of Person"|
                                          Description == "Aslt-police/emerg P"|Description =="Asslt W/dngrs Weapon"|
                                          Description =="Robbery Per Agg"|Description=="Arson"|Description=="Aslt-great Bodily Hm"|
                                          Description == "2nd Deg Domes Aslt"|Description=="Murder (general)"|
                                          Description == "3rd Deg Domes Aslt"|Description=="1st Deg Domes Asslt"|
                                          Description =="Adulteration/poison"|Description =="Looting"|Description=="Disarm a Police Officer" 
                                        |Description=="Theft From Person") 
twenty_sixteen_data <- filter(Cleaned_data,year==2016)  
crime_rate_2016 <-( 8621/415315)*100000 #(Crimes recorded/population)*100K Population via Google
precinct3_2016 <- filter(Cleaned_data,Precinct==3&year==2016)  
precinct4_2016 <- filter(Cleaned_data,Precinct==4&year==2016)  
precinct2_2016 <- filter(Cleaned_data,Precinct==2&year==2016)  
precinct1_2016 <- filter(Cleaned_data,Precinct==1&year==2016)  
precinct5_2016 <- filter(Cleaned_data,Precinct==5&year==2016)  
precinct18_2016 <- filter(Cleaned_data,Precinct==18&year==2016) 
violent_crime_twenty_sixteen<- filter(crimes_2016,Description == 'Crim Sex Cond-rape'|
                                        Description =="Domestic Assault/Strangulation"|Description=="Robbery Of Person"|
                                        Description == "Aslt-police/emerg P"|Description =="Asslt W/dngrs Weapon"|
                                        Description =="Robbery Per Agg"|Description=="Arson"|Description=="Aslt-great Bodily Hm"|
                                        Description == "2nd Deg Domes Aslt"|Description=="Murder (general)"|
                                        Description == "3rd Deg Domes Aslt"|Description=="1st Deg Domes Asslt"|
                                        Description =="Adulteration/poison"|Description =="Looting"|Description=="Disarm a Police Officer" 
                                      |Description=="Theft From Person")  
