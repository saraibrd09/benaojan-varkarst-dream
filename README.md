benaojan-varkarst-dream

Benaoján VarKarst + DREAM_ZS Calibration

Semi-distributed hydrological model (VarKarst) calibrated with the DREAM_ZS algorithm for the Benaoján karst spring (Sierra de Líbar, Málaga, Spain), developed as part of a Master's thesis (TFM) in Water Resources and Environment, Universidad de Málaga.

Repository structure
/data                   Input data (precipitation, temperature, PET, observed discharge)
/MainVarkarstRoutine     VarKarst model, calibration routine (DREAM_ZS), and data formatting scripts
Requirements
MATLAB (R2026a)
Execution workflow
1. Prepare input data

Place data_observed.csv and data_weather.csv inside the /data folder.

data_weather.csv: column t must be in MATLAB datenum format (serial date number).
data_observed.csv: column t must be in calendar date format (dd.mm.yyyy).

Run data_formatting.m first. This converts both CSV files into the .mat structures required by the model:

inputDataWeather.mat
obsData.mat

These .mat files are generated inside the /data folder. Copy them into the MainVarkarstRoutine folder before continuing (the model scripts read them from there).

2. Calibration (DREAM_ZS)

Navigate to:

/MainVarkarstRoutine/varkarstDream/example_1

Files involved: runDREAM_ZS.m, varKarstKGE.m, example_1.m, runVK.m

a. Open varKarstKGE.m and set:

Line 14 → set the address for the inputDataWeather.mat file (only needed the first time you set up)
Line 36 → set the address for the obsData.mat file (only needed the first time you set up)
Lines 40–41 → calibration period range. Note: end always refers to the last day of available data; the other value is the offset (in days) counted backward from end to the start date you want to use.

b. Open example_1.m and set:

Lines 9–10 → Set the Max and Min values/ranges for the 8 calibration parameters
Lines 23–24 → Set the number of Markov chains and number of generations

Note regarding parameter 8 (recharge area): In this thesis, the recharge area was treated as an additional calibrated parameter (see Section 4.3.3 of the thesis) rather than fixed a priori. Users who already have an independently determined recharge area for their study site can instead use only 7 calibrated parameters and fix the recharge area directly, by editing varKarstKGE.m as follows:

Line 7: add Arech = [your value];
Line 24: change to Param(1:7) = parameter(1:7);
Line 25: change to Param(8) = Arech;

c. Navigate to:

/MainVarkarstRoutine/varkarstDream

d. Open runDREAM_ZS.m and press Run.

3. Retrieve calibrated parameters

Open the output file dream_zs_output.txt and locate the calibrated parameter set in the MAP column.

4. Run the final model with calibrated parameters

Go to:

/MainVarkarstRoutine

Files involved: runVK.m, Thornthwaite.m, varkarst.m, inputDataWeather.mat, obsData.mat

Open runVK.m and replace the values of parameters 1–8 with the calibrated values obtained from the MAP column in dream_zs_output.txt. Press Run.

The model output (simulated vs. observed discharge) is generated from this final run.

Data availability

Precipitation and temperature were provided by the SAIH Hidrosur network. PET was calculated using Trasero 2.0 (Padilla & Delgado, 2014). Observed discharge data were provided by the Demarcación Hidrográfica de las Cuencas Mediterráneas Andaluzas (DHCMA).

Citation

If you use this code, please cite this thesis and the original VarKarst model: Hartmann et al. (2013).
