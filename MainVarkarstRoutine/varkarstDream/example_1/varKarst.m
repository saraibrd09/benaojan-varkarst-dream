%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% according to Hartmann et al. (2013, Advances in Water Resources)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [modSim]=varKarst(inputForcing,methodET,Param)

% number of model compartments
n=15;

% reading forcing input
Prec = inputForcing.Prec;
Temp = inputForcing.Temp;

% PET method
Start_EPT = inputForcing.tStart;
End_EPT   = inputForcing.tEnd;

% information of weather station
Station_Alt   = 965; % Altitude of climate station [m ASL]
Mean_Alt      = 965; % Mean Altitude of recharge Area [m ASL]
Temp_Alt_Grad = -0.9; % Temperature Altitude gradient [?C/100m]

% calculate PET
% if no PET input, use Thornthwaite method, can be other methods
if methodET ==1 
    [Epot]=Thornthwaite(Temp,Start_EPT,End_EPT,Station_Alt,Mean_Alt,Temp_Alt_Grad);
else
    [Epot]=inputForcing.PET;
end

% Parameters
a=Param(1); %A soil and epikarst parameter / (0)
Epi_MRT_mean=Param(2); %Kepi mean 15 compartments / (0)
Soi_max_mean=Param(3); %V,s mean 15 compartments / (0)
Epi_max_mean=Param(4); %V,e mean 15 compartments / (0)
arecharge=Param(5); %A recharge paramenter / (0)
agw=Param(6); %A goundwater parameter / (0)
Kconduit=Param(7); %Kgw in the last compartment / (0)
rech_area=Param(8); %Recharge area/ (0) km2

MRT_dummy = Epi_MRT_mean*n/sum(((1:n)/n).^a); %1/Kmax,e / (0)
Epi_MRT=max(1,MRT_dummy*((n-(1:n)+1)/n).^a); %Ke,i / [1,15]
GW_MRT_dummy=1/Kconduit; %1/Kmax,gw / (0)
GW_MRT=1./min(1,GW_MRT_dummy*((1:n)/n).^agw); %Kgw,i / [1,15]

Soi_dummy=Soi_max_mean*n/sum(((1:n)/n).^a); %Vmax,s / (0)
Soi_max=Soi_dummy*((1:n)/n).^a; %VS,i / [1,15]
Epi_dummy=Epi_max_mean*n/sum(((1:n)/n).^a); %Vmax,E / (0)
Epi_max=Epi_dummy*((1:n)/n).^a; %VE,i / [1,15] 
fc=((1:n)/n).^arecharge; %recharge separation / [1,15]

%Variable Initiation for high speed calculations / all [t,15]
Soi=zeros(length(Prec),n); %Volume of water in soil
Epi=zeros(length(Prec),n); %Volume of water in epikarst
Inf=zeros(length(Prec),n); %Volume of infiltration
Eact=zeros(length(Prec),n); %actual evaporation
Exc_Soi=zeros(length(Prec),n); %volume of excess soil water
Exc_Epi=zeros(length(Prec),n); %volume of saturation excess
Rech=zeros(length(Prec),n); %volume of recharge
Rdiff=zeros(length(Prec),n); %volume of diffuse recharge
Rconc=zeros(length(Prec),n); %volume of contentrate recharge
Exc_gw=zeros(length(Prec),n); %excess GW water
GW=zeros(length(Prec),n); %Volume of water in GW
InSurf=zeros(length(Prec),n); %sufrace runoff to next unsaturated compartment
RunOff=zeros(length(Prec),n);%sufrace runoff

%initial conditions
Q_0=25*86400/(rech_area*1E6); %First real data we have
GW_0=Q_0.*GW_MRT ; %Initial volume of groundwater discharge in t=0

%Time loop
for t=1:size(Prec,1)
    if t==1
        Soi_0=zeros(1,n);%Soi_Ini in t=1
        Epi_0=zeros(1,n);%Epi_Ini in t=1
    else
        Soi_0=Soi(t-1,:);%Soi_ini in the others time steps
        Epi_0=Epi(t-1,:);%Epi_Ini in the others time steps
        GW_0 =GW(t-1,:);%GW_Ini in the others time steps
    end % all those 3 are [1,15] because they are calculated in each step of the modelization

    Inf(t,:)=Prec(t,1)+InSurf(t,:);%Infiltration / [t,15]
    Eact_dummy=Epot(t,1).*min(max((Soi_0)./(Soi_max),0),1);%POTENTIAL ET in the 15 compartments / [1,15]

    Soi_dummy=max(Soi_0+Inf(t,:)-Eact_dummy,0);%POTENTIAL Vsoil / [1,15]
    Eact(t,:)=Eact_dummy+min(Soi_0+Inf(t,:)-Eact_dummy,0);%ETR / [t,15]
    Soi(t,:)=min(Soi_max,Soi_dummy);%REAL Vsoil / [t,15]
    Exc_Soi(t,:)=max(0,Soi_dummy-Soi_max);%Volume of water from soil to epikarst / [t,15]     
    Rech_dummy=(Epi_0+Exc_Soi(t,:))./Epi_MRT;%POTENTIAL Volume of water from Epikarst to GW / [1,15]
    Epi_dummy=max(Epi_0+Exc_Soi(t,:)-Rech_dummy,0);%POTENTIAL V epikarst / [1,15]
    Rech(t,:)=min(Epi_0+Exc_Soi(t,:),Rech_dummy);%REAL Volume of water from Epikarst to GW / [t,15] 
    Rdiff(t,:)=(1-fc).*Rech(t,:);%Diffuse recharge / [t,15] 
    Rconc(t,:)=fc.*Rech(t,:);%Concentrate recharge / [t,15] 
    Epi(t,:)=min(Epi_max,Epi_dummy);%REAL V epikarst / [t,15] 
    Exc_Epi(t,:)=max(0,Epi_dummy-Epi_max);%REAL Epikarst runoff / [t,15] 
    for i=1:n
        if i<n
            Exc_gw(t,i)=(GW_0(1,i)+Rdiff(t,i))./GW_MRT(1,i);%REAL Volume of water out from the GW from 1:(n-1)
            GW(t,i)=GW_0(1,i)+Rdiff(t,i)-Exc_gw(t,i);%Volume of water in the GW
        else
            Exc_gw(t,i)=(GW_0(1,i)+Rdiff(t,i)+sum(Rconc(t,:),2))/Kconduit;%REAL Volume of water out from the GW in n
            GW(t,i)=GW_0(1,i)+Rdiff(t,i)+sum(Rconc(t,:),2)-Exc_gw(t,i);%Volume of water in the GW
        end
        
        idx_sat_last = find(Exc_Epi(t,:)>0, 1, 'last' );
        
        if (t<size(Prec,1)) & (idx_sat_last<n)
            Deficit = max(0,Epi_max-Epi(t,:));
            Excess=sum(Exc_Epi(t,:));
            
            for j=idx_sat_last+1:n
                InSurf(t+1,j)=min(Excess,Deficit(j),'includenan');
                Excess = Excess-InSurf(t+1,j);
            end
            RunOff(t+1,n)=Excess/n;                    
        end
        
        if Rech(t,:)<0
            error('Rech<0!');
        end
    end
end

Exc_gw_new=(Exc_gw+RunOff)*((rech_area*1000000)/86400); % L/s
modSim.Q = mean(Exc_gw_new,2);
modSim.Rech = mean(Rech,2);
modSim.Eact = mean(Eact,2);    
end