# We can reduce the dimensions of our dataset in in two main ways. One is by removing variables from the dataset, this can be done using decision trees, or variable selection methods in regression modeling, like doing strpwise regression (where variables are added one at a time if they imporve predication properly and the weakest variables are removed), lasso regression, etc. The other approach is by composing new variables, which are derived from the existing ones, examples of this technique includes PCA, Factor Analysis, SVD.

# PCA (Principal Compoment Analysis): The goal of PCA is to determine a new set of independent variables from the original variables.These new variables are called Principal components.

# Tips for PCA
# 1. Each variable must be scaled/normalized, because of the dependence on variance. (If the variable is X, calculate the sample standard deviation for X and divide every value of X by this standard deviation)
# 2. Outliers must be managed, usually by removing them or transforming the variable (eg take log(X) if there are large outlier values).

# In the exercise below, I want to predict the price for houses in an area, but I want to use only the variables that might be important, and I'll be using PCA for this.

library(AER)
library(help="AER")
library(h2o)
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
# I had to do this in H2O flow to see the variables that are important, and from my deduction, I think I can use just 4 or 5 variables from the original 11 to predict the price of the house. Nice stuff. Now I'll create a regression model to predict the price of houses using the variables my pca suggested. I'll compare this with the one that used all variables. Just to show.

