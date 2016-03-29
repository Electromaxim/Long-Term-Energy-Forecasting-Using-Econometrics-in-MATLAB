function varargout = energyforecast_app(varargin)
% ENERGYFORECAST_APP MATLAB code for energyforecast_app.fig
%      ENERGYFORECAST_APP, by itself, creates a new ENERGYFORECAST_APP or raises the existing
%      singleton*.
%
%      H = ENERGYFORECAST_APP returns the handle to a new ENERGYFORECAST_APP or the handle to
%      the existing singleton*.
%
%      ENERGYFORECAST_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENERGYFORECAST_APP.M with the given input arguments.
%
%      ENERGYFORECAST_APP('Property','Value',...) creates a new ENERGYFORECAST_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before energyforecast_app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to energyforecast_app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% David Willingham, MathWorks
% Copyright 2015 The MathWorks, Inc.

% Edit the above text to modify the response to help energyforecast_app

% Last Modified by GUIDE v2.5 02-Oct-2014 14:09:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @energyforecast_app_OpeningFcn, ...
                   'gui_OutputFcn',  @energyforecast_app_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before energyforecast_app is made visible.
function energyforecast_app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to energyforecast_app (see VARARGIN)

% Choose default command line output for energyforecast_app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes energyforecast_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = energyforecast_app_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loaddata.
function loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load T
load econdata
load meantempmax
TEcon = [T,meantempmax,econ2];
TEcon(end,:) = []; % removing final row as there is incomplete monthly data

TEdates = [num2str(TEcon.Months),repmat(',',length(TEcon.Months),1),num2str(TEcon.Years)];
Tedates_num = datenum(TEdates,'mm,yyyy');

YSeries = TEcon.Properties.VariableNames';

handles.TEcon = TEcon;
handles.TEdates = TEdates;
handles.Tedates_num = Tedates_num;
handles.YSeries = YSeries;
guidata(hObject, handles);

handles.listbox1.String = YSeries;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

% val = handles.listbox1.Value;

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = handles.listbox1.Value;
title('please wait ...')
drawnow
Fin = handles.TEcon(1:end-12,:);
Find = handles.Tedates_num(1:end-12,:);
Fout = handles.TEcon(end-11:end,:);
Foutd = handles.Tedates_num(end-11:end,:);


cols = handles.YSeries(val);
tot = find(strcmp(cols,'MonthlyTotalDemand'));

Y = Fin(:,cols);
YSeries = Y.Properties.VariableNames;
Y = table2array(Y);

nAR = 12; % Number of lags
Spec = vgxset('n', numel(YSeries), 'Constant', true, 'nAR', nAR, 'Series', YSeries);
Spec = vgxvarx(Spec, Y);

Horizon = 12; % Number of quarters
NumPaths = 10000; % Number of Simulations
FY = vgxsim(Spec, Horizon, [], Y, [], NumPaths);
% FY = vgxpred(Spec, Horizon, [], Y, [], NumPaths);

TD = squeeze(FY(:,tot,:)); %Total Demand
mean_sim = mean(TD,2);
std_sim = std(TD,[],2);

hold off
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
legend(char(cols),'forecast','+5%','-5%','actual','Location','Best')

error = mean_sim - Yout(:,1);
errorpct =abs(error)./Yout(:,1)*100;
MAE = mean(abs(error));
MAPE = mean(errorpct(~isinf(errorpct)));

title(['Energy Forecast - Mean Error Pct = ',num2str(MAPE),'%'])
xlabel('Date')
ylabel('Total Monthly Energy Demand')


% --- Executes on button press in backtest.
function backtest_Callback(hObject, eventdata, handles)
% hObject    handle to backtest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = handles.listbox1.Value;

cols = handles.YSeries(val);
tot = find(strcmp(cols,'MonthlyTotalDemand'));
steps = length([108:1:length(handles.Tedates_num)]);

count = 1;
h = waitbar(count/steps,'Please Wait') ;
tic
for i = [108:1:length(handles.Tedates_num)]
    waitbar( count/steps,h)
    TEcontemp = handles.TEcon(1:i,:);
    TEcondates = handles.Tedates_num(1:i,:);
    % Split data into training and test data set.
    Fin = TEcontemp(1:end-12,:);
    Find = TEcondates(1:end-12,:);
    Fout = TEcontemp(end-11:end,:);
    Foutd = TEcondates(end-11:end,:);   

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

    TD = squeeze(FY(:,tot,:)); %Total Demand
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
derror_btest = handles.Tedates_num(I);
mape_btest = MAPE(I);
figure
plot(derror_btest,mape_btest)
dynamicDateTicks
title(['Mean Abs Perc Error Pct - ',num2str(mean(mape_btest)),'%'])
ylabel('Percentage')
xlabel('Date')
legend(strvcat(YSeries))
