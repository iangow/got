%MACRO clus2D(yvars, xvars, cluster_1, cluster_2, dset);
/* This macro was developed by Ian Drummond Gow, Gaizka Ormazabal and
  Daniel Taylor to implement two-way cluster-robust standard errors 
  in SAS. This macro is called with the following syntax:
  
  clus2D(yvars, xvars, cluster_1, cluster_2, dset)
  
  where yvars is the dependent variable of the regression, XVARS is the 
  list of independent variables, CLUSTER_1 is the first variable for clustering
  and CLUSTER_2 is the second variable for clustering, and DSET is the data set
  to be used for the analysis.
  
  Note that the computational intensity of two-way clustering may cause
  problems, particularly if your data set is large or includes many variables,
  such as indicator variables for each firm.
*/

  ods listing close;
  
  /* Do first cluster */
  proc surveyreg data=&dset; 
    cluster &cluster_1;
    model &yvars= &xvars / covb;
    ods output CovB = Cov1;
  quit;
  
  /* Do second cluster */
  proc surveyreg data=&dset;
    cluster &cluster_2;
    model &yvars= &xvars / covb;
    ods output CovB = Cov2 ParameterEstimates = params;
  quit;
  
  /* do interesection cluster*/
  proc surveyreg data=&dset; 
    cluster &cluster_1 &cluster_2; 
    model &yvars= &xvars / covb; 
    ods output CovB = CovI;
  quit;
  
  /* 
    Now get the covariances numbers created above. We calculate the
    two-way cluster-robust covariance matrix
      COV = COV1 + COV2 - COVI
    and then calculate coefficients, standard errors, t-statistics
    and p-values using COV.
  */
  proc iml; 
    reset noprint;
    use params;
    read all var{Parameter} into varnames;
    
    read all var _all_ into b;
    
    /* Read in the three covariance matrices calculated above */
    use Cov1;
    read all var _num_ into x1;
    
    use Cov2;
    read all var _num_ into x2;
    
    use CovI;
    read all var _num_ into x3;
    
    /* Calculate covariance matrix */
    cov = x1 + x2 - x3; 
    
    /* Calculate key statistics */
    dfe = b[1,3];
    stdb = sqrt(vecdiag(cov));
    beta = b[,1];
    t = beta/stdb;
    prob = 1-probf(t#t,1,dfe);
    
    /* Print results */
    ODS listing; 
    print,"Parameter estimates",,varnames beta[format=8.4] stdb[format=8.4]
      t[format=8.4] prob[format=8.4];
    
    /* Create data set for results */
    conc = beta || stdb || t || prob;
    cname = {"estimates" "stderror" "tstat" "pvalue"};
    create clus2dstats from conc [ colname=cname ];
    append from conc;
    conc = varnames;
    cname = {"varnames"};
    create names from conc [ colname=cname ];
    append from conc;
  quit;
  
  data clus2dstats; 
    merge names clus2dstats;
  run;
  
%MEND clus2D;