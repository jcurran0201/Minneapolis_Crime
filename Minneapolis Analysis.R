library(dplyr) 
library(tidyr) 
library(tidyverse) 
library(ggplot2)
library(forcats)
library(broom)  
library(lubridate) 
library(patchwork)  
#What are the most common crimes in each precint? Loop through each precinct and generate a plot 
precincts <- unique(Cleaned_data$Precinct)  
#view(distinct(Cleaned_data)) 
Cleaned_data <- Cleaned_data[ -c(14) ] 
view(Cleaned_data) 
binned_time <- cut(Cleaned_data$Time,breaks = 12)  
Cleaned_data <- cbind(Cleaned_data,x=binned_time)  
Cleaned_data <- Cleaned_data %>%
  rename(Binned_time = x)   
view(unique(Cleaned_data$Binned_time))
violent_crime <- filter(Cleaned_data,Description == 'Crim Sex Cond-rape'|
                          Description =="Domestic Assault/Strangulation"|Description=="Robbery Of Person"|
                          Description == "Aslt-police/emerg P"|Description =="Asslt W/dngrs Weapon"|
                          Description =="Robbery Per Agg"|Description=="Arson"|Description=="Aslt-great Bodily Hm"|
                          Description == "2nd Deg Domes Aslt"|Description=="Murder (general)"|
                          Description == "3rd Deg Domes Aslt"|Description=="1st Deg Domes Asslt"|
                          Description =="Adulteration/poison"|Description =="Looting"|Description=="Disarm a Police Officer" 
                        |Description=="Theft From Person") 
for (precinct in precincts) {
  
  precinct_data <- filter(Cleaned_data, Precinct == precinct)
  p <- ggplot(data = precinct_data, 
              aes(x = reorder(Description, Description, function(x) -length(x)), fill = Description)) +
    geom_bar() +
    geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) +
    labs(title = paste("Bar Graph Ordered by Count - Precinct", precinct),
         x = "Description", y = "Count") +
    theme_minimal() +
    theme(legend.position = "none") +
    coord_flip()
  # Print the plot
  print(p)}
#### What time of the day has the most crimes
ggplot(violent_crime, aes(x = fct_infreq(Binned_time))) + 
  geom_bar(stat = "count", aes(fill = Binned_time)) + 
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) +
  labs(title = "What Times of The Day Have the Most Crimes",
       x = "Time (hours 0-24)", 
       y = "Count") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
#During what part of the day is each violent crime most common?   
ggplot(data = violent_crime, aes(x = Binned_time,y=..count..)) +
  geom_bar(fill = "purple") + 
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) +
  labs(title = "Crime Incidents by Time",
       x = "Time of Incident",y = "Number of Incidents") +theme_minimal() +
  theme( axis.text.x = element_text(angle = 90, hjust = 1),  # Rotate x-axis labels
         strip.text = element_text(face = "bold", size = 10),  # Bold facet labels
         plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),  # Center title
         panel.spacing = unit(1, "lines")  # Increase spacing between facets
  ) + facet_wrap(~ fct_infreq(Description), ncol = 4)  # Order facets by frequency 

#Question 1 Show the relationship between non violent crime and violent crime on a year to year basis in each precinct 
#Make this a stacked bar plot
Cleaned_data <- Cleaned_data %>%
  mutate(Crime_Type = "All Crimes")
violent_crime <- violent_crime %>%
  mutate(Crime_Type = "Violent Crimes")
combined_data <- bind_rows(Cleaned_data, violent_crime)
ggplot(data = combined_data, aes(x = year, fill = Crime_Type)) +
  geom_bar(position = "stack") +
  scale_x_continuous(limits = c(2010, 2016), breaks = seq(2010, 2016, by = 1), oob = scales::squish) +
  scale_fill_manual(values = c("All Crimes" = "magenta", "Violent Crimes" = "green")) +
  labs(title = "Crimes Per Year (Stacked Violent/Non-violent)", x = "Year", 
       y = "Number of Incidents", fill = "Crime Type") +
  annotate("text",x=2016,y=12000,label="01/16-07/16")+ 
  annotate("segment", x = 2015.5, y = 11500,  xend = 2015.75, yend = 10000,arrow = 
             arrow(length = unit(0.2, "inches")), 
             color = "blue", size = 1) +
  theme_minimal()
#Question 2 Show the comparison between non violent crime and violent crime on a month to month basis in each precinct  
ggplot(data = combined_data, aes(x = factor(month, levels = 1:12, 
                                            labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", 
                                                       "Aug", "Sep", "Oct", "Nov", "Dec")), 
                                 fill = Crime_Type)) +  # Use the actual categorical variable
  geom_bar(position = "stack") +
  labs(title = "Violent Crimes Committed in Each Month", 
       x = "Month", 
       y = "Violent Crimes Committed") + 
  scale_x_discrete() +
  scale_fill_manual(values = c("All Crimes" = "purple", "Violent Crimes" = "orange")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Question 3 Linear regression for crimes and violent crimes based on the time of the day  

crime_counts <- combined_data %>%
  mutate(Rounded_Time = ifelse(round(Time, digits = 0) > 23, 23, round(Time, digits = 0))) %>%
  group_by(Rounded_Time) %>%
  summarise(Num_Crimes = n(), .groups = 'drop')
#Linear regression visualization
ggplot(data=crime_counts,aes(x=Rounded_Time,y=Num_Crimes))+ 
  geom_point(color="black")+
    scale_x_continuous(limits = c(0, 23), breaks = seq(0, 23, by = 2)) + 
  theme_classic()+
  labs(title="Linear Regression of amount of Crimes per hour",x="Time of Day",y="Amount of Crimes committed",
       subtitle = "No distinction between violent and non violent crime")+ 
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title = element_text(size = 10),
        panel.grid.major.y = element_line(color = "grey95"))+ 
  geom_smooth(method="lm",se=FALSE,color="red")
model <- lm(Num_Crimes ~ Rounded_Time, data = crime_counts) 
r_squared<- summary(model)$r.squared 
rmse <- sqrt(mean(model$residuals^2)) 
correlation<-cor(crime_counts$Num_Crimes, crime_counts$Rounded_Time)

#Question 4 What is the probability (as a perent) you are the victim of a crime in each year? 
twenty_ten_crime_victim_prob <- (19364/383078)*100 #Found the city population on Google  
twenty_eleven_crime_victim_prob <- (20648/388096)*100
twenty_twelve_crime_victim_prob <- (20506/392837) *100
twenty_thirteen_crime_victim_prob <- (21753/400189)*100 
twenty_fourteen_crime_victim_prob <-(20306/407206) *100
twenty_fifteen_crime_victim_prob <- (18841 /411210) *100
victim_prob <- c(twenty_ten_crime_victim_prob, twenty_eleven_crime_victim_prob, twenty_twelve_crime_victim_prob,
                 twenty_thirteen_crime_victim_prob, twenty_fourteen_crime_victim_prob, twenty_fifteen_crime_victim_prob)

year <- c(2010, 2011, 2012, 2013, 2014, 2015)
crime_df <- data.frame(Year = year, Victim_Probability = victim_prob)
View(crime_df)   
ggplot(data = crime_df, aes(x = Year, y = Victim_Probability)) + 
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Crime Victim Probability by Year as a percent", 
       x = "Year", 
       y = "Victim Probability") +
  theme_minimal()

#Question 5 Project how much crime will occur from July 2016 until the end of the year in Minneapolis?

# Step 1: Assign weights for each year 
weights <- c(`2013` = 0.2, `2014` = 0.3, `2015` = 0.5)

# Filter data for previous years (2013-2015)
previous_years <- Cleaned_data %>% filter(year %in% c(2013, 2014, 2015))

# Step 2: Apply weights to July–Dec crimes for 2013-2015
prev_jul_dec <- previous_years %>%
  filter(month %in% 7:12) %>%
  group_by(year) %>%
  summarise(total_crimes = n(), .groups = "drop") %>%
  mutate(year = as.character(year),  
         weight = weights[year],
         weighted_crimes = total_crimes * weight)

# Step 3: Calculate weighted average for July–Dec (2013–2015)  
#weighted avg formula is (summation of (score*weight))/mean(weights)
weighted_avg_jul_dec <- sum(prev_jul_dec$weighted_crimes) / sum(prev_jul_dec$weight)

# Step 4: Calculate first half (Jan–June) 2016 crimes 
twenty_sixteen <- Cleaned_data %>% filter(year == 2016) 
first_half_2016 <- twenty_sixteen %>% filter(month %in% 1:6) 
print(nrow(first_half_2016)) 

# Step 5: Calculate growth rate of crime in first half of 2016 

prev_jan_jun <- previous_years %>%
  filter(month %in% 1:6) %>%
  group_by(year) %>%
  summarise(total_crimes = n(), .groups = "drop")
#get the average of crimes from 2013-2015 to use as init value in growth rate
avg_prev_jan_jun <- mean(prev_jan_jun$total_crimes, na.rm = TRUE)  

#growth rate = ((Final value - init value)/(init value))*100
growth_rate <- (first_half_2016_count - avg_prev_jan_jun) / avg_prev_jan_jun

# Step 6: Apply weighted average to July–Dec projection for 2016
adjusted_jul_dec_2016 <- weighted_avg_jul_dec * (1 + growth_rate)

# Step 7: Calculate total projected crimes for 2016
total_projected_2016 <- first_half_2016_count + adjusted_jul_dec_2016

# Step 8: Estimate confidence range for projection (±5% variation)
lower_bound <- adjusted_jul_dec_2016 * 0.95
upper_bound <- adjusted_jul_dec_2016 * 1.05

# Step 9: Print results
cat("Weighted July–Dec (2013-2015):", round(weighted_avg_jul_dec), "\n")
cat("Growth Rate for 2016:", round(growth_rate * 100, 2), "%\n")
cat("Projected July–Dec 2016 Crimes:", round(adjusted_jul_dec_2016), "\n") 
cat("Projected July–Dec 2016 Crimes Range:", round(lower_bound), "-", round(upper_bound), "\n")
cat("Total Projected Crimes for 2016:", round(total_projected_2016), "\n")

# Probability of being a crime victim in Minneapolis (2016)
twenty_sixteen_crime_prob <- (18889 / 415315) * 100 
cat("Probability of being a crime victim in Minneapolis in 2016:", round(twenty_sixteen_crime_prob, 3), "%\n")

# Step 10: Visualization with weighted average line
ggplot(prev_jul_dec, aes(x = factor(year), y = total_crimes)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_hline(yintercept = weighted_avg_jul_dec, linetype = "dashed", color = "green") +
  labs(title = "Weighted July–December Crimes (2013–2015)",
       x = "Year", y = "Total Crimes") +
  theme_minimal()
