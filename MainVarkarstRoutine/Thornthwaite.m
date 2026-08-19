
function [EPTpot]=Thornthwaite(Temp,Start_EPT,End_EPT,Station_Alt,Mean_Alt,Temp_Alt_Grad)

% astronomic sunshine length

lat=36.85; % mean latitude of site
Obl=23.439; %Obliquity of the ecliptic
PerSol=182.625; %period between solstices
diffJD=datenum('21.12.0000','dd.mm.yy'); %correction from calendar year
                %to astronomic year (begins with winter solstice)

for t=Start_EPT:End_EPT
    asl(t-Start_EPT+1)=...
        24*(acos(1-(1-tan(lat/180*pi)*tan(Obl/180*pi * cos(pi*(t-diffJD)/PerSol))))/pi);
end

% Calculation of Thornthwaite's Temperature Index I

MonthlyVec=datevec([Start_EPT:1:End_EPT]');

for i=1:12
    Index_Month= MonthlyVec(:,2)==i;
    T_mean(i)=mean(Temp(Index_Month));
end
T_mean(T_mean<0)=0;

I=sum((T_mean/5).^1.514);
a=(0.0675*I^3-7.71*I^2+1792*I+49239)*10^-5;
    
% Thornthwaite's Equation
Temp_cal = Temp;
Temp_cal(Temp<0)=0;
EPTpot(:,1)=0.533.*asl'./12.*(10.*Temp_cal/I).^a;
end