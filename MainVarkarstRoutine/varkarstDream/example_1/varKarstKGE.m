
function [log_L] = varKarstKGE(parameter)
% varKarstKGE call the varKarst model for simulations and calculate the
% likelihood passing to DREAM

% fixed recharge area
%Arech = 2.39; % size of the recharge area
methodET = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Define and read the forcing data                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

forcingData = load('inputDataWeather.mat'); %load('C:\ZONA\MODELO_10\MainVarkarstRoutine\varkarstDream\example_1\inputDataWeather.mat');

% Forcing preparation
inputForcing.Prec = forcingData.inputDataWeather.Prec;
inputForcing.Temp = forcingData.inputDataWeather.Temp;
inputForcing.PET = forcingData.inputDataWeather.PET;
inputForcing.tStart = forcingData.inputDataWeather.t(1);
inputForcing.tEnd = forcingData.inputDataWeather.t(end);

% Parameter
Param(1:8) = parameter(1:8);
%Param(8) = Arech;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Run the varKarst model and read observations               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulation
% run model
[modSim]=varKarst(inputForcing,methodET,Param);
% calibration
Qsim = modSim.Q;

obs = load('obsData.mat'); %load('C:\ZONA\MODELO_10\MainVarkarstRoutine\varkarstDream\example_1\obsData.mat');
% calibration Q
tsim = forcingData.inputDataWeather.t;

tobs = obs.obsData.Q.t;
tobs_num = datenum(tobs);

obs_sel  = obs.obsData.Q.Q(end-6205:end-2920);
tobs_sel = tobs_num(end-6205:end-2920);

[ia,ib] = ismember(tobs_sel,tsim);
obs_cal = obs_sel(ia);
sim_cal = Qsim(ib(ia));

% Excluir días con caudal observado = nan
%idx_valid = obs_cal > 0;
idx_valid = ~isnan(obs_cal);
obs_cal = obs_cal(idx_valid);
sim_cal = sim_cal(idx_valid);

% calculate KGE% Q KGE
n = length(obs_cal);

KGEQ = KGEQCompute(sim_cal,obs_cal);
ED = 1-KGEQ;

gammapdf = gampdf(ED,0.5,1);
log_L = 0.5*n*log(gammapdf);

end

