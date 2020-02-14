#' This is a function for converting categorical variables to numerical. This tranformation helps in avoiding use Gower distance and open the door to use clustering methods that deals with continuous variables
#' @param Data is the dataframe taht contatin both categorical and numerical variables.
#' @return return a transformed dataframe with numerical variables
#' @details #' This is a function for converting categorical variables to numerical. This tranformation helps in avoiding use Gower distance and open the door to use clustering methods that deals with continuous variables
#' @author Rani Basna
#' @import dplyr
#' @export
UFT_func <- function(Data, Seed){
  set.seed(Seed)
  # checking the data format
  if (!is.data.frame(Data)){
    stop("The Data is not in dataframe format")
  }
  # Spliting the data according to their classes
  data_splits <- Data_Classes_Split(Data)
  drops_numerical <-data_splits$numeric
  # droping numerical classes
  data_cate <- Data[ , !(names(Data) %in% drops_numerical)]
  m <- length(data_cate)
  d <- dim(data_cate)[1]
  #
  for (j in 1:m) {
    n <- length(unique(data_cate[,j]))
    S <- as.vector(as.matrix(dplyr::count(data_cate, data_cate[,j], sort = TRUE)[,1])) # the unique values of variable (we did this some that the order match with count and probabilities)
    C <- as.vector(as.matrix(dplyr::count(data_cate, data_cate[,j], sort = TRUE)[,2])) # the count (number of occurance) of the values in the variable
    P <- C/(d*1) # Probabilities
    for (i in 1:n){
      mu <- 0
      L1 <- 0
      L2 <- 1- sum(P^3)
      L3 <- 0
      for (h in 1:n) {
        H <- P[h]*P[i]*(h-i)^2
        L3 <- H + L3
      }
      for (k in 1:i){
        mu1 <- sum((n-k) * P[k])
        L1 <- L1 + mu1
      }
      mu <- ((n -i) - L1) * sqrt(L2/L3)
      for (l in 1:d){
        if (data_cate[l,j] == S[i]){
          data_cate[l,j] <- rnorm(1,mu, P[i])
        }
      }
    }
  }
  return(data_cate)
}
