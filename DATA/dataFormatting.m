% Step 1: Load the CSV file
data_forcing = readtable('data_weather.csv'); % Replace filename or your CSV file path
data_observed = readtable('data_observed.csv'); % Replace filename or your CSV file path

%%
% Step 2: Extract the columns (adjust column names if necessary)
% To create forcing dataset 
t_forcing = data_forcing.t;          % Assuming the column name is 't'
Prec_values = data_forcing.Prec;    % Assuming the column name is 'Prec'
Temp_values = data_forcing.Temp;    % Assuming the column name is 'Temp'
PET_values = data_forcing.PET;      % Assuming the column name is 'PET'

% To create observed dataset
t_observed = data_observed.t;         % Assuming the column name is 't'
Q_values = data_observed.Q;         % Assuming the column name is 'Q'

%%
% Step 3: Create a structure dataset with the data
% Forcing dataset 
inputDataWeather = struct('t', t_forcing, 'Prec', Prec_values, 'Temp', Temp_values, 'PET', PET_values);

% Observed dataset
Q = struct('t', t_observed, 'Q', Q_values);
obsData = struct('Q', Q);

%%
% Step 4: Save the structure into a .mat file
save('inputDataWeather.mat', 'inputDataWeather');

save('obsData.mat', 'obsData');


