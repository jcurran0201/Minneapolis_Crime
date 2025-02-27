# Minneapolis Crime 
### https://www.kaggle.com/datasets/mrisdal/minneapolis-incidents-crime is the link to the original dataset. The crimes.csv dataset was used as the original dataset for the project 
### The crimes.csv dataset was cleaned in order to eliminate columns that were not needed and to eliminate missing data 
### The data from 2013 and 2016 was cleaned sepeatley from other years in order to help save data from those years in the cleaning process. A very large portion of the 2013 and 2016 were eliminated in the intitial data cleaning. 
### The times were also turned into numerical hours and the hours were also binned in a separate column. The bins were split into 2 hour intervals. This was eventually dropped and redone on Cleaned_data 
### The years were also seperated and each year was filitered into a violent and non violent crime section. 

## The analysis    
## Precint 3 Crimes  
# ![Precint 3 crimes](https://github.com/user-attachments/assets/d30e05d8-a9c4-49c5-9b69-731d81d646c9)
## Precinct 4 Crimes  
# ![Precinct 4](https://github.com/user-attachments/assets/9d3c6ed2-a2c5-4160-a185-92c139a91236)

## Precinct 2 Crimes  
# ![Precinct 2](https://github.com/user-attachments/assets/d9e5a0f6-4fc1-4bfb-a134-0f1f8156189f)

## Precinct 1 Crimes  
# ![Precinct 1](https://github.com/user-attachments/assets/2140be96-8952-499c-a325-b7a07cdcdcd0)

## Precinct 5 Crimes   
# ![Precinct 5 plot](https://github.com/user-attachments/assets/1414fa8a-70dd-49ca-80d7-fe2907c1c529)

## Precinct 18 Crimes  
# ![Precinct 18 plot](https://github.com/user-attachments/assets/dc96b3e6-df20-4d43-992c-b34d6280afa5)

## Violent Crimes based on Time of the Day
# ![Rplot violent crimes by time](https://github.com/user-attachments/assets/9e8d3183-bc62-4589-ba4d-b089c3c5d8f1)   
### Violent Crimes tend to occur more late at night and in the early hours of the morning, before 6 AM
## Comparison of Violent and Non-Violent Crimes Over the Years
# ![Stacked plot of violent and non voilent crimes over the years](https://github.com/user-attachments/assets/6155a434-9d95-484c-a235-59dfc8326c2b)  
## Amount of Violent Crimes Committed in Each Month
# ![Violent crimes committed in each month](https://github.com/user-attachments/assets/723d8cb1-f83a-4f6a-bb89-134d9d6adf36)   
### It can be shown that violent and non violent crime spikes in the summer months and then begins to decrease as the fall and winter apporach. 
## Linear Regression of Crimes in each hour of the day
# ![linreg crimes per hour](https://github.com/user-attachments/assets/9e380b18-788a-406e-ad1c-c9aedb03965a)  
### It was found that despite there being a correlation between the crimes committed and the time of the day, does not have a strong linear relatinoship. Despite the correlation coming out to a little over 0.7, the R^2 came out to 0.49 and the RMSE came out to 1908.  
## Probability you are a victim of a crime in Minneapolis
# ![Probability you're a victim over the years](https://github.com/user-attachments/assets/a5496cbb-7c8b-4dd6-a50c-b55771e23729)  
## The probability that you are a victim of a crime in Minneapolis stayed around 4% from 2010-2015

### Weighted July–Dec (2013-2015): 10875  
### Growth Rate for 2016: -5.56 %  
### Projected July–Dec 2016 Crimes: 10271  
### Projected July–Dec 2016 Crimes Range: 9757 - 10784 
### Total Projected Crimes for 2016: 18889  
### It was discovered that the decrease in crime that crime is continuing to decrease in Minneapolis since it's peak in 2013. 





