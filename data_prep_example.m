%% Data Preperation
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
% David Willingham, MathWorks
% Copyright 2015 The MathWorks, Inc.
%% Select Start and End dates to convert to Monthly
ds = '31-Jan-1999';
dE = '30-Jun-2014';
%% Convert the data to Monthly
tic
TEcon = data_prep(ds,dE);
toc