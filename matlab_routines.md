This page contains code for econometric procedures used in the
simulations for the paper *Correcting for Both Cross-Sectional and
Time-Series Dependence in Accounting Research* by Ian Gow, Gaizka
Ormazabal and Daniel Taylor.

### OLS standard errors

This [routine](Code/matlab/regress.m) produces OLS estimates of coefficients
and standard errors.

### Newey-West standard errors

This [routine](Code/matlab/NeweyWestPanelStata.m) produces Newey-West (1987)
standard errors identical to those produced by Stata.

### Fama-MacBeth and Z2

This [routine](Code/matlab/FamaMacBeth_NW.m) produces Fama-MacBeth estimates
and can make either the Newey-West adjustment or the Abarbanell-Bernard
(2000) correction. It also produced Z1 and Z2 statistics.

### Cluster-robust standard errors

This [routine](Code/matlab/clusterreg.m) produces either one- or two-way
clustered standard errors.

\[[Back](readme.md) to main page\]

###### *Last updated: 17 September 2007*
