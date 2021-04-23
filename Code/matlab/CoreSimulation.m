% CoreSimulation routine:
%
% This routine is used in the simulations described in Section 4.0 of 
% Gow, Ormazabal and Taylor. This routine gets the simulated data, 
% calculates the statistics for each of the methods and then saves 
% them in the OUT2 matrix, which is used by the Output routine.

global beta;

% Reset the random number generator
randn('state',2008);

% Row of table
row = row + 1;
rho = AC_X;
beta=1;
beta_vec = [beta; 0];

% Number of regressions
for j=1:num_iter
  toc
  
  % Get data and assign to respective variables
  data = GetData(n,t,Xvol,Evol,rho, rho);
  y = data(:,1);
  X   = [data(:,2) ones(size(y))];
  FIRM  = data(:,3);
  YEAR  = data(:,4);

  % Get OLS coefficient, standard error and t-stat
  ret = regress(y,X,0);
  out2(j,1) = ret(1,1);
  out2(j,4) = ret(1,2);
  out2(j,13) = (ret(1,1)-beta)/ret(1,2);
  
  % Get bootstrap standard errors
  out2(j,21) = Bootstrap(y,X, BS_iter);
  
  % Get Newey-West standard error and t-stat
  ret = NeweyWestPanelStata(y, X, t-1, FIRM, YEAR, 0);
  out2(j,5) = ret(1,2);
  out2(j,14) = (ret(1,1)-beta)/ret(1,2);
  
  % Get FM-t coefficient, standard error and t-stat
  % and Z2 statistic
  ret = FamaMacBeth_NW(y,X,YEAR,beta_vec);
  out2(j,2) = ret(1,1);
  out2(j,6) = ret(1,2);
  out2(j,15) = ret(1,3);
  out2(j,12) = ret(1,5);

  % Get FM-NW standard error and t-stat
  %	for lag length of 1
  ret = FamaMacBeth_NW(y,X,YEAR,beta_vec,'NW',1);
  out2(j,7) = ret(1,2);
  out2(j,16) = ret(1,3);

  % Get FM-i coefficient, standard error and t-stat
  ret = FamaMacBeth_NW(y,X,FIRM,beta_vec);
  out2(j,3) = ret(1,1);
  out2(j,8) = ret(1,2);
  out2(j,17) = ret(1,3);
 
  % Get CL-i standard error and t-stat
  ret = clusterreg(y, X, FIRM);
  out2(j,9) = ret(1,2);
  out2(j,18) = (ret(1,1)-beta)/ret(1,2);

  % Get CL-t standard error and t-stat
  ret = clusterreg(y, X, YEAR);
  out2(j,10) = ret(1,2);
  out2(j,19) = (ret(1,1)-beta)/ret(1,2);

  % Get CL-it standard error and t-stat
  ret = clusterreg(y, X, FIRM, YEAR);
  out2(j,11) = ret(1,2);
  out2(j,20) = (ret(1,1)-beta)/ret(1,2);
  
  out2(j,21) = 0;

end

% Output results
Output
