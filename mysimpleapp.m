function varargout = mysimpleapp(varargin)
% MYSIMPLEAPP MATLAB code for mysimpleapp.fig
%      MYSIMPLEAPP, by itself, creates a new MYSIMPLEAPP or raises the existing
%      singleton*.
%
%      H = MYSIMPLEAPP returns the handle to a new MYSIMPLEAPP or the handle to
%      the existing singleton*.
%
%      MYSIMPLEAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYSIMPLEAPP.M with the given input arguments.
%
%      MYSIMPLEAPP('Property','Value',...) creates a new MYSIMPLEAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mysimpleapp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mysimpleapp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% David Willingham, MathWorks
% Copyright 2015 The MathWorks, Inc.
% Edit the above text to modify the response to help mysimpleapp

% Last Modified by GUIDE v2.5 23-Oct-2014 10:06:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mysimpleapp_OpeningFcn, ...
                   'gui_OutputFcn',  @mysimpleapp_OutputFcn, ...
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


% --- Executes just before mysimpleapp is made visible.
function mysimpleapp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mysimpleapp (see VARARGIN)

% Choose default command line output for mysimpleapp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mysimpleapp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mysimpleapp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot(rand(10))