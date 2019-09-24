%%%%%%%%%%%%%%%%%%%%%% GUI Initialisation and standard headers %%%%%%%%%%%%%%%%%%%%%%%%
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
handles.output = hObject;   % Choose default command line output for part3_gui
guidata(hObject, handles);  % Update handles structure

axes(handles.axes1)
path1 = '..\assg1\h1.jpg';
% path1 = '..\assg1\im01.jpg';
img1 = imread(path1);
im1 = image(img1);
im1.ButtonDownFcn = @img1_clickFcn;
set(handles.panel_img1,'Title',path1)

axes(handles.axes2)
path2 = '..\assg1\h2.jpg';
% path2 = '..\assg1\im02.jpg';
img2 = imread(path2);
im2 = image(img2);
im2.ButtonDownFcn = @img2_clickFcn;
set(handles.panel_img2,'Title',path2)

% --- Outputs from this function are returned to the command line.
function varargout = part3_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = get(handles.im1_pt1,'String');
uiwait(gcf)
img1_mat = getpoints(handles,1);
img2_mat = getpoints(handles,2);
img1 = imread(get(handles.panel_img1,'Title'));
img2 = imread(get(handles.panel_img2,'Title'));
varargout{1} = img1_mat;
varargout{2} = img2_mat;
varargout{3} = img1;
varargout{4} = img2;
%delete(hObject);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%% Image clicks: Logs points to GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function img1_clickFcn(hObject, eventdata, handles)
    handles = guidata(hObject);

    currentpt = get(gca, 'CurrentPoint');
    row  = currentpt(1,2);
    col  = currentpt(1,1);
    
    idx1 = 1;
    cur_handle = sprintf('im1_pt%d', idx1);
    colors = ['r', 'c', 'y', 'b'];
    while idx1 <= 4
        if not(strcmp(get(handles.(cur_handle),'String'),""))    % if not empty (occupied)
            idx1 = idx1 + 1;
            cur_handle = sprintf('im1_pt%d', idx1);
        else
            set(handles.(cur_handle),'String',['Row = ', num2str(row), ', Column = ', num2str(col)]);
            hold on ; plot(col,row,'o','MarkerSize',5,'MarkerFaceColor', colors(idx1),'MarkerEdgeColor',colors(idx1)); drawnow; hold off;
            idx1 = 10;
        end
    end 
function img2_clickFcn(hObject, eventdata, handles)
    handles = guidata(hObject);

    currentpt = get(gca, 'CurrentPoint');
    row  = currentpt(1,2);
    col  = currentpt(1,1);
    
    idx1 = 1;
    cur_handle = sprintf('im2_pt%d', idx1);
    colors = ['r', 'c', 'y', 'b'];
    while idx1 <= 4
        if not(strcmp(get(handles.(cur_handle),'String'),""))    % if not empty (occupied)
            idx1 = idx1 + 1;
            cur_handle = sprintf('im2_pt%d', idx1);
        else
            set(handles.(cur_handle),'String',['Row = ', num2str(row), ', Column = ', num2str(col)]);
            hold on ; plot(col,row,'o','MarkerSize',5,'MarkerFaceColor', colors(idx1),'MarkerEdgeColor',colors(idx1)); drawnow; hold off;
            idx1 = 10;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Reset buttons: clears points %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function reset1_Callback(hObject, eventdata, handles)
hold off;
handles = guidata(hObject);
for i = 1:4
    tag = sprintf('im1_pt%d',i);
    handles.(tag).String = "";
end
axes(handles.axes1)
path1 = get(handles.panel_img1,'Title');
img1 = imread(path1);
im1 = image(img1);
im1.ButtonDownFcn = @img1_clickFcn;

function reset2_Callback(hObject, eventdata, handles)
hold off;
handles = guidata(hObject);
for i = 1:4
    tag = sprintf('im2_pt%d',i);
    handles.(tag).String = "";
end
axes(handles.axes2)
path2 = get(handles.panel_img2,'Title');
img2 = imread(path2);
im2 = image(img2);
im2.ButtonDownFcn = @img2_clickFcn;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculate and swap buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        uiresume(gcbf);
%         contents = cellstr(get(handles.part_no,'String'));
%         if strcmp(contents{get(handles.part_no,'Value')},'Part 3')
%             f = warndlg('part 3','Success');
%             uiresume(gcbf);
%         else
%             f = warndlg('part 4','Success');
%             uiresume(gcbf);
%         end   
    end
function swap_Callback(hObject, eventdata, handles)
% hObject    handle to reset2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold off;
handles = guidata(hObject);
reset1_Callback(hObject,eventdata,handles);
reset2_Callback(hObject,eventdata,handles);
path1 = get(handles.panel_img1,'Title');
path2 = get(handles.panel_img2,'Title');
temp = path1;

set(handles.panel_img1,'Title',path2);
set(handles.panel_img2,'Title',temp);

axes(handles.axes1)
img1 = imread(path2);
im1 = image(img1);
im1.ButtonDownFcn = @img1_clickFcn;

axes(handles.axes2)
img2 = imread(path1);
im2 = image(img2);
im2.ButtonDownFcn = @img2_clickFcn;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dropdown menu %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % --- Executes on selection change in part_no.
% function part_no_Callback(hObject, eventdata, handles)
% % hObject    handle to part_no (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns part_no contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from part_no
% contents = cellstr(get(handles.part_no,'String'));
% if strcmp(contents{get(handles.part_no,'Value')},'Part 3')
%     path1 = '..\assg1\h1.jpg';
%     path2 = '..\assg1\h2.jpg';
% else
%     path1 = '..\assg1\im01.jpg';
%     path2 = '..\assg1\im02.jpg';
% end
% axes(handles.axes1)
% img1 = imread(path1);
% im1 = image(img1);
% im1.ButtonDownFcn = @img1_clickFcn;
% set(handles.panel_img1,'Title',path1)
% 
% axes(handles.axes2)
% img2 = imread(path2);
% im2 = image(img2);
% im2.ButtonDownFcn = @img2_clickFcn;
% set(handles.panel_img2,'Title',path2)
% 
% reset1_Callback(hObject,eventdata,handles);
% reset2_Callback(hObject,eventdata,handles);
% % --- Executes during object creation, after setting all properties.
% function part_no_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to part_no (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %guidata(hObject,handles);
    %data = guidata(hObject)

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Other functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mat = getpoints(handles,num)
mat = zeros(3,4);
for i = 1:4
    tag = sprintf('im%d_pt%d',num,i);
    s = get(handles.(tag),'String');
    com = strfind(s,',');
    equ = strfind(s,'=');
    row = str2num(s(equ(1,1)+2:com-1));
    col = str2num(s(equ(1,2)+2:end));
    %mat(i,:) = [row, col];
    mat(:,i) = [col ; row ; 1];
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
