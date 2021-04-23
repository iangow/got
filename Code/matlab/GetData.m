function data = GetData(N,T,Xvol,Evol,rho_X,rho_E)
% Function to generate simulated panel data as described in Gow, Ormazabal and
% Taylor (2007).
% 
% SYNTAX:  data = GetData(N,T,Xvol,Evol,rho_X,rho_E) 
% where
%  N = Number of firms
%  T = Number of years
%  Xvol = Cross-sectional correlation of X
%  Evol = Cross-sectional correlation of errors
%  rho_X = Autocorrelation coefficient for firm-effect portion of X
%  rho_E = Autocorrelation coefficient for firm-effect portion of \epsilon
%
%  data = [y X firm year]
%
global beta;

  % INPUTS
  
  % Basic assumptions about stochastic processes
  beta = 1;  % y = x + epsilon
  Xbar = 0;  % E[X] = 0
  
  % Distributional assumptions
  sigma_X = 1;   % Standard deviation of the independent variable
  sigma_E = 2;   % Standard deviation of errors
  
  %%%%%%%%%%
  % GENERATE X VALUES
  %%%%%%%%%%
  sigma_mu_T = sqrt(Xvol)*sigma_X;
  sigma_mu_F = sqrt(sigma_X^2 - sigma_mu_T^2);
  
  % Generate YEAR effects for X
  mu_T = (randn(T,1) * sigma_mu_T * ones(1,N))';
  
  % Generate FIRM effects for X 
  v = randn(N,T) * sqrt(1-rho_X^2)*sigma_mu_F;
  
  mu_F(:,1) = v(:,1);
  for t=2:T
    mu_F(:,t) = mu_F(:,t-1) * rho_X + v(:,t);
  end
  
  X = Xbar + mu_T + mu_F;
  
  %%%%%%%%%%
  % GENERATE epsilon VALUES
  %%%%%%%%%%
  sigma_gamma_T = sqrt(Evol)*sigma_E;
  sigma_gamma_F = sqrt(sigma_E^2 - sigma_gamma_T^2);
  
  % Generate YEAR effects for epsilon
  gamma_T = (randn(T,1) * sigma_gamma_T * ones(1,N))';
  
  % Generate FIRM effects for epsilon 
  nu = randn(N,T) * sqrt(1-rho_E^2)*sigma_gamma_F;
  
  gamma_F(:,1) = nu(:,1);
  for t=2:T
    gamma_F(:,t) = gamma_F(:,t-1) * rho_X + nu(:,t);
  end
  
  epsilon = gamma_T + gamma_F;
  
  % Generate FIRM variables
  firm  = [1:N]' * ones(1,T);

  % Generate YEAR variables
  year  = ([1:T]' * ones(1,N))';
  
  % Calculate y using population model
  y = beta * X + epsilon;
  
  % Return data, converting matrices into vectors.
  data = [y(1:N*T)' X(1:N*T)' firm(1:N*T)' year(1:N*T)'];

end
