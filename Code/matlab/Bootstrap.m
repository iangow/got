function out = Bootstrap(y, X, k);

	% Number of observations in the dataset received
	n = size(y,1);

	for i=1:k
		% Generate random sample of n observations
		f = ceil(n.*rand(n,1));
		y2 = y(f,:);
		X2 = X(f,:);
		
		% Run regression
		temp = regress(y2,X2,0);

		% Store estimated coefficient 
		temp2(i,:) = temp(1,1);
	end
	
	% Return the standard deviation of the coefficients on the first
	% variable.
	% It would be easy to return the full vector of estimated coefficients.
	out = std(temp2(:,1));
	
end
		