# Tests of R function using Mitchell Petersen's test-data

# Read the data             
test <- read.table(
      url(paste("http://www.kellogg.northwestern.edu/",
            "faculty/petersen/htm/papers/se/",
            "test_data.txt",sep="")),
    col.names=c("firmid", "year", "x", "y"))

# The fitted model
fm <- lm(y ~ x, data=test)

source("http://www.people.hbs.edu/igow/GOT/Code/cluster2.R")

# Tests
library(sandwich); library(lmtest)
coeftest(fm)                                    # OLS
coeftest(fm, vcov=vcovHC(fm, type="HC0"))       # White
coeftest.cluster(test,fm, cluster1="firmid")    # Clustered by firm
coeftest.cluster(test,fm, cluster1="year")      # Clustered by year
coeftest.cluster(test,fm, cluster1="firmid",
                          cluster2="year")      # Clustered by firm and year

# Here is another test
# from Francois Cocquemas <francois.cocquemas@gmail.com>
data <- rbind(iris, c(as.numeric(NA), 3.0, 5.1, 1.8, "virginica"))
cat("Pass test 1: ", nrow(data) == 151, "\n")
fm <- lm(Sepal.Length ~ Sepal.Width, iris)
cat("Pass test 2: ", nrow(estfun(fm)) == 150, "\n")
coeftest.cluster(data, fm, "Species")
