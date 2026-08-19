function [KGE]=KGEQCompute(sim,obs)
% compute modified KGE
obsMu = mean(obs);
simMu = mean(sim);
obsSigma = std(obs);
simSigma = std(sim);
covAllSO = cov(sim,obs);
covSO    = covAllSO(1,2);
r        = covSO/(obsSigma*simSigma);
alpha    = simSigma/obsSigma;
beta     = simMu/obsMu;
KGE     = 1-sqrt((r-1)^2+(alpha-1)^2+(beta-1)^2);
end