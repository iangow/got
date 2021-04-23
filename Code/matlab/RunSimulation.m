% Run Simulation routine:
%
% This routine is used in the simulations described in Section 4.0 of 
% Gow, Ormazabal and Taylor. This routine sets the basic parameters of
% of the simulation and controls the overall process. The simulation
% can be invoked simply by calling this routine.

clc
clear

% By setting batch=0, it is possible to just one set of
% parameter values
batch = 1;
row = 0;

% Indicate that the table header has not been created
texttodo = 1;


% Reset the timer
tic;

% SIMULATION PARAMETERS
num_iter = 1000;  % Number of iterations overall
BS_iter = 2;      % Number of iterations for bootstrap
n = 200;          % Number of firms
t = 40;           % Number of years

if not(batch)           
  Xvol = 0.0;     
  Evol = 0.0;       
  AC_X = 0;       
  AC_E = 0; 
  
  CoreSimulation
  
elseif batch
  % This code runs through each panel of Tables 1 and 2.
  for tab=1:3 %%%%%% WAS 1:3
    if tab==1   
      AC_X = 0;     % Autocorr coefficient for X: AR(1)
      AC_E = 0;     % Autocorr coefficient for E (error term): AR(1)
    elseif tab==2
      AC_X = 0.5;
      AC_E = 0.5;
    elseif tab==3
      AC_X = 0.8;     % Autocorr coefficient for X: AR(1)
      AC_E = 0.8;
    end

      % This code runs through each row of the panel
      for sect=1:4 %%%% WAS 1:4
        if sect==1
          Xvol = 0;
          Evol = 0;
        elseif sect==2
          Xvol = 0.25;  % Level of cross-sectional correlation in regressors
          Evol = 0.25;  % Level of cross-sectional correlation in errors
        elseif sect==3
          Xvol = 0.50;
          Evol = 0.50;
        elseif sect==4
          Xvol = 0.75;
          Evol = 0.75;
        end
      
      text = sprintf('Processing row: %3d', row);
      disp(text);
      CoreSimulation
    end
  end
end

% Save output to file
OutputDisplay
toc
save results_t40a4
