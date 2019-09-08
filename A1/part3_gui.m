function varargout = part3_gui(varargin)

% PART3_GUI MATLAB code for part3_gui.fig
%      PART3_GUI, by itself, creates a new PART3_GUI or raises the existing
%      singleton*.
%
%      H = PART3_GUI returns the handle to a new PART3_GUI or the handle to
%      the existing singleton*.
%
%      PART3_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PART3_GUI.M with the given input arguments.
%
%      PART3_GUI('Property','Value',...) creates a new PART3_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before part3_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to part3_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help part3_gui

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @part3_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @part3_gui_OutputFcn, ...
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

% --- Executes just before part3_gui is made visible.

function part3_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to part3_gui (see VARARGIN)

% Choose default command line output for part3_gui
handles.output = hObject;
%handles.numberOfClicks = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes part3_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axes(handles.axes1)
img1 = imread('.\assg1\im01.jpg');
im1 = image(img1);
im1.ButtonDownFcn = @img1_clickFcn;

axes(handles.axes2)
img2 = imread('.\assg1\im02.jpg');
im2 = image(img2);
im2.ButtonDownFcn = @img2_clickFcn;


% --- Outputs from this function are returned to the command line.

function varargout = part3_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function img1_clickFcn(hObject, eventdata, handles)
    handles = guidata(hObject);

    currentpt = get(gca, 'CurrentPoint');
    row  = round(currentpt(1,2));
    col  = round(currentpt(1,1));
    
    idx1 = 1;
    cur_handle = sprintf('im1_pt%d', idx1);
    
    while idx1 <= 4
        if not(strcmp(get(handles.(cur_handle),'String'),""))    % if not empty (occupied)
            idx1 = idx1 + 1;
            cur_handle = sprintf('im1_pt%d', idx1);
        else
            set(handles.(cur_handle),'String',['Row = ', num2str(row), ', Column = ', num2str(col)]);
            idx1 = 10;
        end
    end
    %guidata(hObject,handles);
    %data = guidata(hObject)
    
function img2_clickFcn(hObject, eventdata, handles)
    handles = guidata(hObject);

    currentpt = get(gca, 'CurrentPoint');
    row  = round(currentpt(1,2));
    col  = round(currentpt(1,1));
    
    idx1 = 1;
    cur_handle = sprintf('im2_pt%d', idx1);
    
    while idx1 <= 4
        if not(strcmp(get(handles.(cur_handle),'String'),""))    % if not empty (occupied)
            idx1 = idx1 + 1;
            cur_handle = sprintf('im2_pt%d', idx1);
        else
            set(handles.(cur_handle),'String',['Row = ', num2str(row), ', Column = ', num2str(col)]);
            idx1 = 10;
        end
    end


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
    % hObject    handle to calculate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    handles = guidata(hObject);
    idx = 0;
    for i = 1:2
        for j = 1:4
            tag = sprintf('im%d_pt%d',i,j);
            if strcmp(get(handles.(tag),'String'),"")    %if empty
                f = warndlg('Please choose 4 points in each image','Error');
                return
            else
                idx = idx + 1;
            end
        end
    end
    
    if idx == 8
        f = warndlg('Success','Success');
    end

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
for i = 1:2
    for j = 1:4
        tag = sprintf('im%d_pt%d',i,j);
        handles.(tag).String = "";
    end
end











