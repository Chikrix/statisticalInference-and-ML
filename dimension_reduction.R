# We can reduce the dimensions of our dataset in in two main ways. One is by removing variables from the dataset, this can be done using decision trees, or variable selection methods in regression modeling, like doing strpwise regression (where variables are added one at a time if they imporve predication properly and the weakest variables are removed), lasso regression, etc. The other approach is by composing new variables, which are derived from the existing ones, examples of this technique includes PCA, Factor Analysis, SVD.

# PCA (Principal Compoment Analysis): The goal of PCA is to determine a new set of independent variables from the original variables.These new variables are called Principal components.

# Tips for PCA
# 1. Each variable must be scaled/normalized, because of the dependence on variance. (If the variable is X, calculate the sample standard deviation for X and divide every value of X by this standard deviation)
# 2. Outliers must be managed, usually by removing them or transforming the variable (eg take log(X) if there are large outlier values).

# In the exercise below, I want to predict the price for houses in an area, but I want to use only the variables that might be important, and I'll be using PCA for this.

library(AER)
library(h2o)
library(tidyverse)
localH2o = h2o.init(ip = "127.0.0.1", port = 54321)
data("HousePrices")
head(HousePrices)
dim(HousePrices)
h2o_housing_data <- as.h2o(HousePrices)
housing_data_response <- h2o_housing_data[,1]
head(housing_data_response)
housing_data_covariates <- h2o_housing_data[, -1]  # Every other thing except the response variable
colnames(housing_data_covariates)
h2o_pca <- h2o.prcomp(training_frame = housing_data_covariates, k = 11, max_iterations = 1000, 
                      transform = "STANDARDIZE", pca_method = "GramSVD")
summary(h2o_pca)

head(housing_data_covariates)
# I did this in H2O flow to see the variables that are important, and from my deduction, I think I can use just 4 or 5 variables from the original 11 to predict the price of the house. Nice stuff. Now I'll create a regression model to predict the price of houses using the variables my pca suggested. I'll compare this with the one that used all variables. Just to show.

# init data 
getColumnIndex <- function(frameColumnNames, column) {
  index = frameColumnNames %in% column
  if (any(index)) {
    return(which(index))
  } else {
    return(NULL)
  }
}

dataset_split <- h2o.splitFrame(h2o_housing_data)
housing_train <- dataset_split[[1]]
housing_test <- dataset_split[[2]]
housing_df <- as.data.frame(h2o_housing_data)
housing_validation <- as.h2o(sample_n(housing_df, nrow(housing_df) * 0.3))
predictor_indices <- getColumnIndex(colnames(housing_train), 
                                   c("lotsize", "bedrooms", "bathrooms", "driveway", "garage" ))
outcome_index <- getColumnIndex(colnames(h2o_housing_data), "price")
# Build model
model_regr <- h2o.glm(x = predictor_indices, y = outcome_index, training_frame = housing_train, 
                      validation_frame = housing_validation, max_iterations = 1000, family = "gaussian", 
                      solver = "IRLSM", alpha = 1, intercept = T)
summary(model_regr)
get_mean_of_difference <- function(model, confirmation_set, response_index) {
  predicted_prices = h2o.predict(model, confirmation_set)
  dif_pred_and_actual = tibble(predicted=as.vector(predicted_prices), 
                                       actual = as.vector(housing_test[,response_index]))
  dif_pred_and_actual$difference <- dif_pred_and_actual$actual - dif_pred_and_actual$predicted
  print(head(dif_pred_and_actual))
  return(mean(dif_pred_and_actual$difference))
}
pca_modeled <- get_mean_of_difference(model_regr, housing_test, 1) 
pca_modeled
# From the above, remember I used the predictor variables I got from the pca analysis, on comparing the predicted
# values of that model, with the actual value, I noticed the mean of the difference between these was 383.50, let
# me now compare this with a model created with all variables.
outcome_index <- getColumnIndex(colnames(h2o_housing_data), "price")
predictors_indices <- (1:length(colnames(h2o_housing_data)))[-outcome_index]
model_regr_all <- h2o.glm(x = predictor_indices, y = outcome_index, training_frame = housing_train, 
                      validation_frame = housing_validation, max_iterations = 1000, family = "gaussian", 
                      solver = "IRLSM", alpha = 1, intercept = T)
not_pca_modeled <- get_mean_of_difference(model_regr_all, housing_test, 1)
not_pca_modeled

# turns out the models returns the same thing