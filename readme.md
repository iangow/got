This site contains additional analyses and portions of the code used in the [paper](paper.html) *Correcting for Cross-Sectional and Time-Series Dependence in Accounting Research* by [Ian Gow](https://github.com/iangow),
Gaizka Ormazabal and [Daniel Taylor](http://www.danieltayloranalytics.com).

### SAS code

This [macro](Code/clus2D.sas) produces two-way cluster-robust standard errors using SAS. 
See below for code illustrating its use and discussion of how to produce two-way cluster-robust standard errors using other packages.

### R code

This [R code](Code/cluster2.R.html) includes a function `coeftest.cluster` which can be applied to an existing model fit toreturn table output based on two-way cluster-robust standard errors.  
See [here](Code/cluster.test.R.html) for code illustrating its use against data from Mitchell Petersen's [website](http://www.kellogg.northwestern.edu/faculty/petersen/htm/).
This code was adapted from code provided by [Mahmood Arai](http://people.su.se/~ma/).

### Matlab routines and simulation code

As part of our simulations, we developed a number of general purpose econometric routines.
Details on these are provided [here](matlab_routines.html). To run the simulation you need access to Matlab and the files contained [here](Code/matlab).

### Test code and data sets

**Cost of capital pseudo-data:** To illustrate the use of two-way
cluster-robust standard errors in popular packages, we provide
pseudo-data sets for our second application on the cost of capital in
[Stata](Data/CoCdata.dta), [SAS](Data/cocdata.sas7bdat) and
[Matlab](Data/CoCdata.mat) formats (to respect others\' copyright, the
data are fabricated, only the variable labels are retained from our
analysis).

This [file](Code/CoC_Matlab.txt) illustrates the application of two-way
cluster-robust standard errors in Matlab. This
[file](Code/Cluster_test.sas) contains code to do the same in SAS using
our [macro](Code/clus2D.sas) ([here](Code/Cluster_test.lst) is the
output). This [file](Code/CoC_Stata.txt) illustrates two-way clustering
in Stata using the *cluster2.ado* macro from Mitchell Petersen\'s
[site](http://www.kellogg.northwestern.edu/faculty/petersen/htm/).

###### *Last updated: [April 25, 2008](update.html)*


