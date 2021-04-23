/* This code assumes that it is being run from a
	directory containing clus2D.sas and coc cocdata.sas7bdat */

libname pwd '.';
/*	88 chars per line, and do not center printout */
options linesize=88 nocenter replace;

%include './clus2D.sas';

/* Get data for regression */
data reg_data;
	set pwd.CoCdata; * 'cocdata.sas7bdat';
run;

/* Run the CLUSTER macro */
%clus2D(coc_brav, ffa_beta1 ffa_beta2 ffa_beta3 ffa_beta4 size bm volatility
vs, GVKEY, FYEAR, reg_data);
