clear all, clc;
% generate parameter
Param(1)=2.399; % a soil and epikarst (soil/epikarst depth variability constant)
Param(2)=54.789; % K_epi (epikarst mean storage coefficient)
Param(3)=142.133; % S_soil (mean soil storage capacity)
Param(4)=91.518; % S_epi (mean epikarst storage capacity)
Param(5)=6.801; % a recharge (recharge separation variability constant)
Param(6)=2.862; % a groundwater (groundwater variability constant)
Param(7)=7.003; % K_gw in n=15 (conduit storage coefficient)
% (MANTENER VALOR)
Param(8)=60.711; % Recharge area km2
% set PET method
methodET = 1; % 1: use Thornthwaite, 2: use PET dataset

% read forcing and observed Q
load inputDataWeather.mat;
load obsData.mat;

inputForcing.tStart = inputDataWeather.t(1);
inputForcing.tEnd = inputDataWeather.t(end);
inputForcing.Prec = inputDataWeather.Prec;
inputForcing.Temp = inputDataWeather.Temp;
inputForcing.PET = inputDataWeather.PET;

% run VK
[modSim] = varKarst(inputForcing,methodET,Param);
%% 

% output
tSim = inputDataWeather.t;
QSim = modSim.Q;

tObs = obsData.Q.t;
QObs = obsData.Q.Q;
tObsNum = datenum(tObs);

% overlap of QObs and QSim
indQ = ismember(tSim,tObsNum);
QSimOverlap = QSim(indQ);

% plot
figure (1);
subplot (2,1,1);
plot(tObs,QObs,'r-',tObs,QSimOverlap,'b--'),grid;
ylabel('Discharge [L/s]');
legend('Observation','Simulation','location','NorthWest');

% Correlación Q observado vs. Q simulado
idx_valid = ~isnan(QObs) & ~isnan(QSimOverlap);
correlation = corr(QObs(idx_valid), QSimOverlap(idx_valid));

subplot (2,1,2);

scatter(QObs(idx_valid), QSimOverlap(idx_valid)), grid;
hold on;
p = polyfit(QObs(idx_valid), QSimOverlap(idx_valid), 1);% Ajustar una línea de tendencia (polinomio de grado 1)
y_fit = polyval(p, QObs(idx_valid));% Generar valores ajustados de y para la línea de tendencia
plot(sort(QObs(idx_valid)), polyval(p, sort(QObs(idx_valid))), 'r:', 'LineWidth', 0.1);% Dibujar la línea de tendencia

xlabel('Sim. Discharge [L/s]');
ylabel('Obs. Discharge [L/s]');
title(['Correlation = ', num2str(correlation)]);

hold off;
