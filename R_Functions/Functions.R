#' This is s small function the split the data according to thier types (numerica, integers or factors)
#' @param Data is the dataframe we are spliting it's variables to different classes.
#' @return return a list that each element contain the coloumns that belong to specific class
#' @details This function split the data to different classes depending on the data type that is contained in each variable in the data
#' @author Rani Basna
#' @export
Data_Classes_Split<- function(Data){
  # checking the data format
  if (!is.data.frame(Data)){
    stop("The data is not in dataframe format")
  }
  # spliting the data
  Airway_spilts <- split(names(Data),sapply(Data, function(x) paste(class(x), collapse=" ")))
  return(Airway_spilts)
}

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
                    #asthmatic_wheeze = if_else(asthmatic_wheeze == "yes", 1L,0L),
                    #wheezeSB = if_else(wheezeSB == "yes",1L,0L),
                    #current_rhinitis = if_else(current_rhinitis == "yes", 1L,0L),
                    #exacerbations = if_else(exacerbations == "yes",1L,0L),
                    #fam_asthma_allergy = if_else(fam_asthma_allergy == "yes", 1L,0L),
                    #fam_bronch_emphys = if_else(fam_bronch_emphys== "yes",1L,0L),
                    #IgEorSPT = if_else(IgEorSPT == "yes",1L,0L),
                    gender = if_else(gender == "male", 1L,0L))
  return(Airway2)
}


bined_converted_func <-  function(converted_data, original_data){
  #cbind(converted_data, original_data[data_split$numeric] %>% scale()) 
  scaled_num_data <- original_data %>% select_if(is.double) %>% scale() %>% as.data.frame()
  converted_df <- cbind(converted_data, scaled_num_data)
  
  #scaled_data <- original_data %>% mutate_if(is.numeric, scale)
  #cbind(food_cate_to_num, rand_food_data2[rand_food_spilts$numeric] %>% scale()) 
}




