%% Backtesting Script for Vector Autoregressive Models
%
% David Willingham, MathWorks
% Copyright 2015 The MathWorks, Inc.
%% Import Economic, Energy Data

load T % from dataprep1_convert_monthly
load econdata % from dataprep2_convert_monthly
load meantempmax % from dataprep3_weather

% T2 = array2table(econ2,'VariableNames',headers(2,:));
TEcon = [T,meantempmax,econ2];
TEcon(end,:) = []; %last row of data is incomplete
TEdates = [num2str(TEcon.Months),repmat(',',length(TEcon.Months),1),num2str(TEcon.Years)];
Tedates_num = datenum(TEdates,'mm,yyyy');

%% Creating BackTest Loop
% i = [120:12:length(Tedates_num)];
steps = length([108:1:length(Tedates_num)]);

count = 1;
h = waitbar(count/steps,'Please Wait') ;
tic
for i = [108:1:length(Tedates_num)]
    waitbar( count/steps,h)
    TEcontemp = TEcon(1:i,:);
    TEcondates = Tedates_num(1:i,:);
    % Split data into training and test data set.
    Fin = TEcontemp(1:end-12,:);
    Find = TEcondates(1:end-12,:);
    Fout = TEcontemp(end-11:end,:);
    Foutd = TEcondates(end-11:end,:);   

    % choose which columns to build model off
    cols = {'MonthlyTotalDemand','MonthlyAvgPrice','MonthlyMaxPrice','MonthlyMinPrice','meanmaxtemp','meanmintemp'}; %backtest 1
    % cols = {'MonthlyTotalDemand','MonthlyAvgPrice','MonthlyMaxPrice','MonthlyMinPrice','meanmaxtemp','meanmintemp','EMP','GSP','CON'}; %backtest 2
    % cols = {'MonthlyTotalDemand','meanmaxtemp', 'meanmintemp', 'POP','EMP','GSP'}; %backtest 3
    % cols = {'MonthlyTotalDemand','MonthlyAvgPrice', 'meanmaxtemp', 'meanmintemp', 'POP','EMP','GSP'}; %backtest 4
    % cols = {'MonthlyTotalDemand','MonthlyAvgPrice','POP','EMP','GSP'}; %backtest 5
    % cols = {'MonthlyTotalDemand','MonthlyAvgPrice','POP','EMP','GSP','CON'}; %backtest 6
    Y = Fin(:,cols);
    YSeries = Y.Properties.VariableNames;
    Y = table2array(Y);
    
    nAR = 12; % Number of lags
    Spec = vgxset('n', numel(YSeries), 'Constant', true, 'nAR', nAR, 'Series', YSeries);
    Spec = vgxvarx(Spec, Y);
    
    % Simulation of model
    % Choose a horizon and number of simulation paths.f
    Horizon = 12; % Number of quarters
    NumPaths = 10000; % Number of Simulations
    FY = vgxsim(Spec, Horizon, [], Y, [], NumPaths);

    TD = squeeze(FY(:,1,:)); %Total Demand
    mean_sim = mean(TD,2);
    std_sim = std(TD,[],2);
    
    Yout = table2array(Fout(:,cols));
    
    error = mean_sim - Yout(:,1);
    errorpct =abs(error)./Yout(:,1)*100;
    MAE(i,:) = mean(abs(error));
    MAPE(i,:) = mean(errorpct(~isinf(errorpct)));
    count = count+1;
end
toc
close(h)
%% Plotting Error
I = find(MAPE ~= 0);
derror_btest = Tedates_num(I);
mape_btest = MAPE(I);
plot(derror_btest,mape_btest)
dynamicDateTicks
title(['Mean Abs Perc Error Pct - ',num2str(mean(mape_btest)),'%'])
ylabel('Percentage')
xlabel('Date')
legend(strvcat(YSeries))