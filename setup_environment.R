library(downloader)
dataUrl = "https://raw.githubusercontent.com/QUT-BDA-MOOC/FLbigdataStats/master/bank_customer_data.csv"
download.file(url = dataUrl, destfile = "BankCustomerData.csv")
bank_customer_data = read.csv("BankCustomerData.csv")

head(bank_customer_data)
colnames(bank_customer_data)
dim(bank_customer_data)

# Installing H20 in R
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }
pkgs <- c("statmod","RCurl","jsonlite")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}
install.packages("h2o", type="source", repos="http://h2o-release.s3.amazonaws.com/h2o/rel-vajda/1/R")

