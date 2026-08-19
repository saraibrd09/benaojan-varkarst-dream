
%% Problem settings defined by user
DREAMPar.d = 8;         % Dimension of the problem
DREAMPar.lik = 2;      % Likelihood 2 (log likelihood)

%% Initial sampling and parameter ranges
Par_info.initial = 'latin';         % Latin hypercube sampling
Par_info.boundhandling = 'reflect'; % Explicit boundary handling: reflection
Par_info.min = [0.10  1.00  00.00  00.00  0.10  0.10  1.00  20.00];   % If 'latin', min values
Par_info.max = [4.00  60.0  250.0  250.0  7.00  6.00  20.0  70.00];  % If 'latin', max values

%% Define name of function (.m file) for posterior exploration
Func_name = 'varKarstKGE';

%% Optional settings
options.modout = 'yes';                % Return model (function) simulations of samples (yes/no)?
options.parallel = 'yes';              % Run each chain on a different core
options.save = 'yes';                  % Save workspace DREAM during run
options.print = 'no';

%% Define method to use {'dream','dream_zs','dream_d','dream_dzs'}
method = 'dream_zs';
DREAMPar.N = 8;                             % Number of Markov chains
DREAMPar.T = 8000;                          % Number of generations

%% Run DREAM package
[chain,output,FX,Z] = DREAM_package(method,Func_name,DREAMPar,Par_info,[],options);

dirSave = 'C:\ZONA\MODELO_10\MainVarkarstRoutine\varkarstDream\example_1';
fileNameSave = 'res_example_1.mat';
save(fullfile(dirSave,fileNameSave),'chain','output','FX','Z','Func_name','DREAMPar','Par_info','options')
