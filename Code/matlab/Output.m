% Output routine:
%
% This routine is used in the simulations described in Section 4.0 of 
% Gow, Ormazabal and Taylor. This code takes data from the OUT2 matrix
% produced by the CoreSimulation routine, summarizes it, does some 
% calculations, and places results in the OUT matrix.

% Collect together the statistics
% Actual standard errors for various estimators
SE_actual         = std(out2(:,1));
SE_FM_t_actual    = std(out2(:,2));
SE_FM_i_actual    = std(out2(:,3));

% Mean estimated standard errors for various approaches
SE_OLS    = mean(out2(:,4));
SE_NW     = mean(out2(:,5));
SE_FM_t   = mean(out2(:,6));
SE_FM_NW  = mean(out2(:,7));
SE_FM_i   = mean(out2(:,8));
SE_Cl_i   = mean(out2(:,9));
SE_Cl_t   = mean(out2(:,10));
SE_Cl_2   = mean(out2(:,11));

% Collect the Z2 statistics
Z2        = out2(:,12);

% Collect the t-statistics
t_OLS     = out2(:,13);
t_NW      = out2(:,14);
t_FM_t    = out2(:,15);
t_FM_NW   = out2(:,16);
t_FM_i    = out2(:,17);
t_Cl_i    = out2(:,18);
t_Cl_t    = out2(:,19);
t_Cl_2    = out2(:,20);

% Calculate rejection rates
sz = 0.01;
cv = norminv(1-sz/2,0,1);
rej_OLS = size(find(abs(t_OLS)>cv),1)/size(t_OLS,1);
rej_NW = size(find(abs(t_NW)>cv),1)/size(t_NW,1);
rej_FM = size(find(abs(t_FM_t)>cv),1)/size(t_FM_t,1);
rej_FM_NW = size(find(abs(t_FM_NW)>cv),1)/size(t_FM_NW,1);
rej_FM_i = size(find(abs(t_FM_i)>cv),1)/size(t_FM_i,1);
rej_Z2 = size(find(abs(Z2)>cv),1)/size(Z2,1);

cv = tinv(1-sz/2,n-1);
rej_Cl_i = size(find(abs(t_Cl_i)>cv),1)/size(t_Cl_i,1);

cv = tinv(1-sz/2,t-1);
rej_Cl_t = size(find(abs(t_Cl_t)>cv),1)/size(t_Cl_t,1);

cv = tinv(1-sz/2,min(t-1,n-1));
rej_Cl_2 = size(find(abs(t_Cl_2)>cv),1)/size(t_Cl_2,1);

% Calculate correlation between Z2 statistic and FM-t t-statistic
corr_Z2 = corr(Z2, t_FM_t);

% Store results in row of OUT matrix
if texttodo text1 = 'num_iter,n,T,Xvol,Evol,AC_X,AC_E,'; end
tout = [num_iter n t Xvol Evol AC_X AC_E];

% Add  Actual, OLS, N-W 
if texttodo text1 = strcat(text1, 'Actual,OLS,N-W,'); end
tout = [tout SE_actual SE_OLS SE_NW];

% Add CL-i, CL-t, CL-2
if texttodo text1 = strcat(text1, 'Cl-F,Cl-T,Cl-2,'); end
tout = [tout SE_Cl_i SE_Cl_t SE_Cl_2  ];

% Add FM-t-actual, FM-t, FM-NW, FM-i-actual, FM-i
if texttodo text1 = strcat(text1, 'FM-t-Actual,FM-t,FM-NW,FM-i-actual,FM-i,'); end
tout = [tout SE_FM_t_actual SE_FM_t SE_FM_NW SE_FM_i_actual SE_FM_i ];

% Add rejection rates for the various methods
if texttodo text1 = strcat(text1, 'rej_Z2,rej_FM,rej_FM_NW,corr_Z2,'); end
tout = [tout rej_Z2 rej_FM rej_FM_NW corr_Z2 ];
if texttodo text1 = strcat(text1, 'rej_OLS,rej_Cl_i,rej_Cl_t,rej_Cl_2,'); end
tout = [tout rej_OLS rej_Cl_i rej_Cl_t rej_Cl_2 ];
if texttodo text1 = strcat(text1, 'rej_FM_i,rej_NW,'); end
tout = [tout rej_FM_i rej_NW ];

% Wrap up output
if texttodo text1 = strcat(text1, '\n'); end
texttodo = 0;

out(row,:) = tout;
