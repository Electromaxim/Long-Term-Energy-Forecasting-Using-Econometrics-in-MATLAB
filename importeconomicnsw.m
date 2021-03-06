%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: C:\AE\energyforecast\IE_Economic_Forecast_2014_FINAL.xlsx
%    Worksheet: qLCO5
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2014/08/29 11:51:32
%
% David Willingham, MathWorks
% Copyright 2015 The MathWorks, Inc.
%% Import the data
[~, ~, raw] = xlsread('IE_Economic_Forecast_2014_FINAL.xlsx','qLCO5','A339:CG402');

%% Exclude columns with non-numeric cells
I = ~all(cellfun(@(x) (isnumeric(x) || islogical(x)) && ~isnan(x),raw),1); % Find columns with non-numeric cells
raw(:,I) = [];

%% Create output variable
econ = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw I;

%% Import the data, extracting spreadsheet dates in MATLAB serial date number format (datenum)
[~, ~, raw, dateNums] = xlsread('C:\AE\energyforecast\IE_Economic_Forecast_2014_FINAL.xlsx','qLCO5','A339:A402','',@convertSpreadsheetDates);

%% Replace date strings by MATLAB serial date numbers (datenum)
R = ~cellfun(@isequalwithequalnans,dateNums,raw) & cellfun('isclass',raw,'char'); % Find spreadsheet dates
raw(R) = dateNums(R);

%% Create output variable
econdates = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw dateNums R;

%% Import the data
[~, ~, raw] = xlsread('C:\AE\energyforecast\IE_Economic_Forecast_2014_FINAL.xlsx','qLCO5','BM5:BU68');

%% Create output variable
econ2 = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw;

%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: C:\AE\energyforecast\IE_Economic_Forecast_2014_FINAL.xlsx
%    Worksheet: qLCO5
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2014/08/29 11:55:42

%% Import the data, extracting spreadsheet dates in MATLAB serial date number format (datenum)
[~, ~, raw, dateNums] = xlsread('C:\AE\energyforecast\IE_Economic_Forecast_2014_FINAL.xlsx','qLCO5','A5:A68','',@convertSpreadsheetDates);

%% Replace date strings by MATLAB serial date numbers (datenum)
R = ~cellfun(@isequalwithequalnans,dateNums,raw) & cellfun('isclass',raw,'char'); % Find spreadsheet dates
raw(R) = dateNums(R);

%% Create output variable
econ2dates = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw dateNums R;

%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: C:\AE\energyforecast\IE_Economic_Forecast_2014_FINAL.xlsx
%    Worksheet: qLCO5
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2014/08/29 11:57:15

%% Import the data
[~, ~, IEEconomicForecast2014FINALS30_0] = xlsread('C:\AE\energyforecast\IE_Economic_Forecast_2014_FINAL.xlsx','qLCO5','A2:CG2');
[~, ~, IEEconomicForecast2014FINALS31_0] = xlsread('C:\AE\energyforecast\IE_Economic_Forecast_2014_FINAL.xlsx','qLCO5','A4:CG4');
headers = [IEEconomicForecast2014FINALS30_0;IEEconomicForecast2014FINALS31_0;];
headers(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),headers)) = {''};
headers = headers(:,3:end);
%% Clear temporary variables
clearvars IEEconomicForecast2014FINALS30_0 IEEconomicForecast2014FINALS31_0;

%% combine data
econ(:,63:71) = econ2;

clear econ2 econ2dates

econ(:,2) = interp1(econdates(52:end),econ(52:end,2),econdates,'linear', 'extrap');

econ(:,3) = [];
headers(:,3) = [];