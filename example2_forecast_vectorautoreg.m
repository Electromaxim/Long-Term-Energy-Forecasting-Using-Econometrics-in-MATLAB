%% Medium / Long Term Energy Forecasting with Econometrics
%
% Goal - Produce a reliable med term forecasting model for Energy Demand
%
% Challenge - current med/long term models in Australia are regression
% based. These models are now incorrect as demand has been decreasing.
% An econometrics based model is dynamica and hence can capture the up &
% down swings that may occur in the future.
%
% Current model is Vector Autoregressive Model vgxvarx
%
% Data - Data used is historical Monthly Demand data for NSW along with
% Sydney Temperature.
%
%
% David Willingham, MathWorks
% Copyright 2015 The MathWorks, Inc.
%% Import Economic and Energy Data

% Uncomment if you wish to show date pre-processing, which aggregates the data to monthly
% takes about 100s
% ds = '31-Jan-1999';
% dE = '30-Jun-2014';
% 
% tic
% TEcon = data_prep(ds,dE);
% toc

% Data has been save as mat files to save time loading
load T
load econdata
load meantempmax
TEcon = [T,meantempmax,econ2];
TEcon(end,:) = []; % removing final row as there is incomplete monthly data

% Uncomment show how the model looks before the downturn
% TEcon = TEcon(1:130,:); 

TEdates = [num2str(TEcon.Months),repmat(',',length(TEcon.Months),1),num2str(TEcon.Years)];
Tedates_num = datenum(TEdates,'mm,yyyy');

% Split data into training and test data set.
Fin = TEcon(1:end-12,:);
Find = Tedates_num(1:end-12,:);
Fout = TEcon(end-11:end,:);
Foutd = Tedates_num(end-11:end,:);

%% select cols used based on names
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice','MonthlyMaxPrice','MonthlyMinPrice','meanmaxtemp','meanmintemp'}; %backtest 1
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice','MonthlyMaxPrice','MonthlyMinPrice','meanmaxtemp','meanmintemp','EMP','GSP','CON'}; %backtest 2
cols = {'MonthlyTotalDemand','meanmaxtemp', 'meanmintemp', 'POP','EMP','GSP'}; %backtest 3
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice', 'meanmaxtemp', 'meanmintemp', 'POP','EMP','GSP'}; %backtest 4
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice','POP','EMP','GSP'}; %backtest 5
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice','POP','EMP','GSP','CON'}; %backtest 6
Y = Fin(:,cols);
YSeries = Y.Properties.VariableNames;
Y = table2array(Y);

%% Set up the model, VAR(12)
% Set up model and estimate parameters

nAR = 12; % Number of lags
Spec = vgxset('n', numel(YSeries), 'Constant', true, 'nAR', nAR, 'Series', YSeries);
Spec = vgxvarx(Spec, Y);

%% Simulation of model
% Choose a horizon and number of simulation paths.f
Horizon = 12; % Number of months
NumPaths = 10000; % Number of Simulations
FY = vgxsim(Spec, Horizon, [], Y, [], NumPaths);
% FY = vgxpred(Spec, Horizon, [], Y, [], NumPaths);

TD = squeeze(FY(:,1,:)); %Total Demand
mean_sim = mean(TD,2);
std_sim = std(TD,[],2);


plot(Find,Y(:,1));
% plot([Y(:,1);mean_sim])
% hold on
% plot(Y(:,1))

dynamicDateTicks
x = length(Y(:,1))+ [1:Horizon];
hold on
plot(Foutd,mean_sim,'g')
plot(Foutd,mean_sim + 1.96*std_sim, 'r:', 'lineWidth', 2)
plot(Foutd,mean_sim - 1.96*std_sim, 'r:', 'lineWidth', 2)
dynamicDateTicks
Yout = table2array(Fout(:,cols));
plot(Foutd,Yout(:,1),'m')
legend(char(cols),'forecast','upper95%','lower95%','actual','Location','Best')

error = mean_sim - Yout(:,1);
errorpct =abs(error)./Yout(:,1)*100;
MAE = mean(abs(error));
MAPE = mean(errorpct(~isinf(errorpct)));

title(['Energy Forecast - Mean Error Pct = ',num2str(MAPE),'%'])
xlabel('Date')
ylabel('Total Monthly Energy Demand')


%% Show model right before the downturn

% Show how the model looks before the downturn
TEcon = TEcon(1:133,:); 
TEdates = [num2str(TEcon.Months),repmat(',',length(TEcon.Months),1),num2str(TEcon.Years)];
Tedates_num = datenum(TEdates,'mm,yyyy');

% Split data into training and test data set.
Fin = TEcon(1:end-12,:);
Find = Tedates_num(1:end-12,:);
Fout = TEcon(end-11:end,:);
Foutd = Tedates_num(end-11:end,:);

% select cols used based on names
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice','MonthlyMaxPrice','MonthlyMinPrice','meanmaxtemp','meanmintemp'}; %backtest 1
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice','MonthlyMaxPrice','MonthlyMinPrice','meanmaxtemp','meanmintemp','EMP','GSP','CON'}; %backtest 2
cols = {'MonthlyTotalDemand','meanmaxtemp', 'meanmintemp', 'POP','EMP','GSP'}; %backtest 3
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice', 'meanmaxtemp', 'meanmintemp', 'POP','EMP','GSP'}; %backtest 4
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice','POP','EMP','GSP'}; %backtest 5
% cols = {'MonthlyTotalDemand','MonthlyAvgPrice','POP','EMP','GSP','CON'}; %backtest 6
Y = Fin(:,cols);
YSeries = Y.Properties.VariableNames;
Y = table2array(Y);

% Set up the model, VAR(1)
% Set up model and estimate parameters

nAR = 12; % Number of lags
Spec = vgxset('n', numel(YSeries), 'Constant', true, 'nAR', nAR, 'Series', YSeries);
Spec = vgxvarx(Spec, Y);

% Simulation of model
% Choose a horizon and number of simulation paths.f
Horizon = 12; % Number of quarters
NumPaths = 10000; % Number of Simulations
FY = vgxsim(Spec, Horizon, [], Y, [], NumPaths);
% FY = vgxpred(Spec, Horizon, [], Y, [], NumPaths);

TD = squeeze(FY(:,1,:)); %Total Demand
mean_sim = mean(TD,2);
std_sim = std(TD,[],2);

figure
plot(Find,Y(:,1));
dynamicDateTicks
x = length(Y(:,1))+ [1:Horizon];
hold on
plot(Foutd,mean_sim,'g')
plot(Foutd,mean_sim + 1.96*std_sim, 'r:', 'lineWidth', 2)
plot(Foutd,mean_sim - 1.96*std_sim, 'r:', 'lineWidth', 2)
dynamicDateTicks
Yout = table2array(Fout(:,cols));
plot(Foutd,Yout(:,1),'m')
legend('historical','forecast','upper95%','lower95%','actual')

error = mean_sim - Yout(:,1);
errorpct =abs(error)./Yout(:,1)*100;
MAE = mean(abs(error));
MAPE = mean(errorpct(~isinf(errorpct)));

title(['Energy Forecast before downturn - Mean Error Pct = ',num2str(MAPE),'%'])
xlabel('Date')
ylabel('Total Monthly Energy Demand')

%% Optimal Lag Order - Optional

% nARmax = 12;
% 
% AICtest = zeros(nARmax,1);
% 
% for i = 1:nARmax
%     Spec = vgxset('n', numel(YSeries), 'Constant', true, 'nAR', i, 'Series', YSeries);
%     [Spec,SpecStd, LLF] = vgxvarx(Spec, Y);
%     AICtest(i) = aicbic(LLF,Spec.NumActive,Spec.T);
% end
% [AICmin, nAR] = min(AICtest);
% 
% figure
% plot(AICtest);
% hold on
% scatter(nAR,AICmin,'filled','b');
% title('\bfOptimal Lag Order with Akaike Information Criterion');
% xlabel('Lag Order');
% ylabel('AIC');
% hold off
