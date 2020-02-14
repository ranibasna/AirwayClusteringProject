args = commandArgs(trailingOnly=TRUE)

#' This is a function that convert the original raw data into binary data set
#' @param Data is the dataframe of the original raw data we got form the WASA and OLIN.
#' @return return a dataframe with categorical variables are of binary (1,0) form as of class int
#' @details This is a function that convert the original raw data into binary data set
#' @author Rani Basna
#' @import tidyverse
#' @export

library(tidyverse)
Get_Binary_data <- function(Data){
  # checking the data format
  if (!is.data.frame(Data)){
    stop("The Data is not in dataframe format")
  }
  # droping lopnr
  # Selecting Specific Variables under the selection creteria. other_CVD all yes
  drops <- c("lopnr","kohort","urbanization","rhinitis_ever","wheeze_ever")
  Airway2 <- Data[ , !(names(Data) %in% drops)]
  
  # this is only to adjust the smoking varaible to three categories Basically replacing number 0 with Never-Smoker
  Airway2 <- Airway2 %>% mutate(ever_smoker20py=replace(ever_smoker20py, ever_smoker20py==0, 'Never-smoker')) %>% as.data.frame()
  # replacing ever_Somoker variable with integer values
  Airway2$ever_smoker20py <- ifelse(Airway2$ever_smoker20py == 'Never-smoker',0, ifelse(Airway2$ever_smoker20py == '<=20 packyears',1, ifelse(Airway2$ever_smoker20py == '>20 packyears',2,0)))
  # converting the ever_somke to integer variable
  Airway2$ever_smoker20py <- as.integer(Airway2$ever_smoker20py)
  
  Airway2 <- mutate(Airway2, Longstanding_cough = if_else(Longstanding_cough == "Yes", 1L, 0L),
                    Sputum_production = if_else(Sputum_production == "Yes", 1L,0L),
                    Chronic_productive_cough = if_else(Chronic_productive_cough == "Yes", 1L, 0L),
                    Recurrent_wheeze = if_else(Recurrent_wheeze == "Yes", 1L,0L),
                    exp_dust_work = if_else(exp_dust_work == "Yes",1L,0L),
                    gender = if_else(gender == "male", 1L,0L))
  return(Airway2)
}


# defining the first argument
filename <- args[1]
# reading the data
airway_original_data <- read.csv(file = filename)
# running the get_binary_data
Airway2_binary <- Get_Binary_data(Data = airway_original_data)
# saving the resulted binary data
write.csv(Airway2_binary, file = args[2])











