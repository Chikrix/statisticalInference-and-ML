# In this exercise, we'll be goruping customers into responsiveness to telemarketting effers.
library(h2o)
localH2o <- h2o.init(ip = "127.0.0.1", port = 54321)
bankCustomerData <-  h2o.uploadFile("BankCustomerData.csv", destination_frame = "", parse = T, header = T,
                                sep = ",", na.strings = c("unknown"), progressBar = FALSE, parse_type = "CSV") 
head(bankCustomerData)
colnames(bankCustomerData)
cluster_dataset <- bankCustomerData[, c(-11, -21)]
dim(cluster_dataset)
cluster_model <- h2o.kmeans(training_frame = cluster_dataset, k = 3, standardize = T, init = "Random")
summary(cluster_model)
cluster_model <- h2o.kmeans(training_frame = cluster_dataset, k = 2, standardize = T, init = "Random")
summary(cluster_model)
cluster_model <- h2o.kmeans(training_frame = cluster_dataset, k = 5, standardize = T, init = "Random")
summary(cluster_model)
cluster_model <- h2o.kmeans(training_frame = cluster_dataset, k = 10, standardize = T, init = "Random")
summary(cluster_model)
# Repeat with several clusters
