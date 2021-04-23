function ret = clusterreg(y, X, g, varargin)
% This routine performs OLS estimation with either one- or
% two-way cluster-robust standard errors.
%
% SYNTAX: ret = clusterreg(y, X, g, varargin)
%
% where y is the dependent variable, X is the matrix of regressors,
% g is the first dimension of clustering and h is the (optional)
% second dimension of clustering. Note: y, g, and h should be vectors of 
% equal length and X should have the same number of observations as y.
%
% ret = [b, se, t], the estimated coefficients (b), the estimated standard
%		errors (se), and t-statistics (t).

  if nargin < 3 || nargin > 4
    error('Either 1 or 2 cluster variables are required');
  end
  
  [N, k] = size(X);

  % Calculate (X'*X)^(-1)
  if N < 10000
      [q r] = qr(X,0);
      xpxi = (r'*r)\eye(k);
    else % use Cholesky for very large problems
      xpxi = (X'*X)\eye(k);
  end;
 
  % calculate Bhat.
  pinvX = pinv(X);
  b = pinvX*y;

  % calculate residuals
  e = y - X*b;
  
  % Calculate variance robust to clustering on the first variable supplied.
  varBhat = singlecluster(xpxi, X, e, g);
  
  % If two cluster variables are supplied, adjust for the second cluster
  % variable.
  if nargin == 4
      h = varargin{1};
      gh = [g h];
      % Add the component attributable to the second cluster
      temp =  varBhat + singlecluster(xpxi, X, e, h);
      % Subtract the variance attributable to the intersection cluster. See
      % p.8 of "Robust Inference with Multi-way Clustering"
      % by A. Colin Cameron, Jonah B. Gelbach, and Douglas L. Miller for more
      % detail.
      varBhat = temp -  singlecluster(xpxi, X, e, gh);
  end
  
  % Calculate standard errors and t-stats
  se = sqrt(diag(varBhat));
  t = b ./ se;

  % Return the calculated values
  ret = [b se t];

  function varB = singlecluster(xpxi, X, e, g)
  % Nested function that handles a single cluster.
  
  % Identify unique clusters
    G = unique(g, 'rows');
    M = size(G,1);
    
    % Now calculate the "meat" of the sandwich variance estimator.
    % See "Robust Inference with Multi-way Clustering"
    % by A. Colin Cameron, Jonah B. Gelbach, and Douglas L. Miller for more
    % detail.
    mid = 0;    
    
    % This code handles clusters defined by more than one variable. It
    % treats observations having the same value for ALL cluster
    % variables as members of the same cluster.
    for i=1:size(G,1)
      test=[1:size(g,1)]';
      for j=1:size(G,2)
        test2 = find(g(:,j)==G(i,j));
        test=intersect(test,test2);
      end
      X_g = X(test,:);
      e_g = e(test,:);
      mid = mid + X_g'*e_g*e_g'*X_g;
    end;
  
    % Calculate cluster-robust variance matrix estimate
    q_c = (N-1)/(N-k)*M/(M-1);
    varB = q_c*xpxi * mid * xpxi;
    
  end

end