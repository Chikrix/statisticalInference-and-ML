
# We'll be using H20 here
library(h2o)
library(tidyverse)
library(downloader)

# Start the H20 server locally
localH20 <- h2o.init(ip = "127.0.0.1", port = 54321)
# Load the dataset 
dataUrl = "https://raw.githubusercontent.com/QUT-BDA-MOOC/FLbigdataStats/master/bank_customer_data.csv"
download.file(url <- dataUrl, destfile = "BankCustomerData.csv")
user_market_data <- h2o.uploadFile("BankCustomerData.csv", destination_frame = "", parse = T, header = T,
                                   sep = ",", na.strings = c("unknown"), progressBar = FALSE,
                                   parse_type = "CSV" )
summary(user_market_data)
typeof(user_market_data)
class(user_market_data)

sample_frame <- h2o.splitFrame(user_market_data, ratios = 0.2)[[1]]
user_marketData_sample <- as.data.frame(sample_frame)
colnames(user_marketData_sample)

user_marketData_sample %>%
  select(y, job) %>%
  sample_n(20)

(user_marketData_sample %>%
  group_by(y, job) %>%
  tally() -> by_y_job)

View(by_y_job)

ggplot(data = by_y_job, aes(x = job, y = n, fill = y)) +
  geom_bar(stat = "identity", position = "dodge")


