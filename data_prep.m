function TEcon = data_prep(ds,dE)
% The data used for the Long Term energy forecasting case study has come 
% from 3 different data sources:
% 1. Historical Energy Demand for the state of NSW from Australian Energy
% Market Operator (AEMO)
% 2. Economic Data for the state of NSW from AEMO
% 3. Historicual Temperature for Sydney from Bureau of Meteorology (BOM)
%
% The data is sampled at different rates, some daily, some monthly some
% annually. In this function, we convert everything to monthly
%
% David Willingham, MathWorks, Sept 2014
% david.willingham@mathworks.com.au
%% Data Preperation 

T = dataprep1_convert_monthly(ds,dE); % Energy Demand 
% http://www.aemo.com.au/Electricity/Data/Price-and-Demand/Aggregated-Price-and-Demand-Data-Files

T2 = dataprep2_economicmonthly(ds,dE); % Economic Data
% http://aemo.com.au/Electricity/Planning/Forecasting/National-Electricity-Forecasting-Report/NEFR-Supplementary-Information

meantempmax = dataprep3_weather(ds,dE); % Weather Data
% http://www.bom.gov.au/climate/data/
TEcon = [T,meantempmax,T2];