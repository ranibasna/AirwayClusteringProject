#' This is a function that run the preprocessing of the original data and then cluster the data using k-means algorithm
#' @param original_raw_data is the dataframe of the original raw data we got form the WASA and OLIN.
#' @return return a a k-means object
#' @details This is a function that run the preprocessing of the original data and then cluster the data using k-means algorithm
#' @author Rani Basna
#' @export
AirwaClusteringKmeans  <- function(original_raw_data){
  Airway2 <- Get_Binary_data(original_raw_data)
  Airway_cate_to_num_only_cate  <- UFT_func(Airway2, Seed = 33)
  converted_airway <- bined_converted_func(converted_data = Airway_cate_to_num_only_cate, original_data = Airway2)
  set.seed(111)
  k_converted <- kmeans(converted_airway, centers = 6, nstart = 100)
  return(k_converted)
}


#testing should be deleated after that
#original_data <-  read.csv('/Users/xbasra/Documents/Data/Airway_Clustering/Original_Data/Airway Disease Phenotyping Data Sets5/WSAS And OLIN Airway Disease Phenotyping.csv')
#airway_k <- AirwaClusteringKmeans(original_data)
