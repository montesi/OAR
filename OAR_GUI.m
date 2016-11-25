function varargout = OAR_GUI(varargin)
% OAR_GUI M-file for OAR_GUI.fig
%      OAR_GUI, by itself, creates a new OAR_GUI or raises the existing
%      singleton*.
%
%      H = OAR_GUI returns the handle to a new OAR_GUI or the handle to
%      the existing singleton*.
%
%      OAR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OAR_GUI.M with the given input arguments.
%
%      OAR_GUI('Property','Value',...) creates a new OAR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OAR_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OAR_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OAR_GUI

% Last Modified by GUIDE v2.5 28-Nov-2005 11:07:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OAR_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OAR_GUI_OutputFcn, ...
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


% --- Executes just before OAR_GUI is made visible.
function OAR_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OAR_GUI (see VARARGIN)

%initialize model
set(handles.rad_RB,'Value',0);
set(handles.deg_RB,'Value',1);
handles.angles.mult=180/pi;
set(handles.symm_CB,'Value',0);

handles.angles.beta=pi;
handles.angles.delta=0;
handles.angles.gamma=0;
handles.angles.VR=0;

handles.is_rad = get(handles.rad_RB,'Value');
handles.is_symm = get(handles.symm_CB,'Value');
handles = set_angles(handles);

set(handles.print_PB,'enable','off');
set(handles.movie_PB,'enable','off');

handles.nfig=0;

% Choose default command line output for OAR_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OAR_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OAR_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in symm_CB.
function symm_CB_Callback(hObject, eventdata, handles)
% hObject    handle to symm_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.is_symm = get(hObject,'Value');
if handles.is_symm
    set(handles.sm_ET,'enable','off');
    set(handles.am_ET,'enable','off');
    set(handles.delta_ET,'enable','off');
    set(handles.sm_ST,'enable','off');
    set(handles.am_ST,'enable','off');
    set(handles.delta_ST,'enable','off');
    handles.angles.delta=0;
    set(handles.VR_ST,'enable','off');
    set(handles.VR_ET,'enable','off','string',0);
    handles.angles.VR=0;
    
else
    set(handles.sm_ET,'enable','on');
    set(handles.am_ET,'enable','on');
    set(handles.delta_ET,'enable','on');
    set(handles.sm_ST,'enable','on');
    set(handles.am_ST,'enable','on');
    set(handles.delta_ST,'enable','on');
    set(handles.VR_ST,'enable','on');
    set(handles.VR_ET,'enable','on');
end
handles=set_angles(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of symm_CB


% --- Executes on button press in deg_RB.
function deg_RB_Callback(hObject, eventdata, handles)
% hObject    handle to deg_RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deg_RB
handles.is_rad=1-get(hObject,'value');
if handles.is_rad;
    set(handles.rad_RB,'value',1);
    handles.angles.mult=1;
    handles=set_angles(handles);
else
    set(handles.rad_RB,'value',0);
    handles.angles.mult=180/pi;
    handles=set_angles(handles);
end
guidata(hObject, handles);

% --- Executes on button press in rad_RB.
function rad_RB_Callback(hObject, eventdata, handles)
% hObject    handle to rad_RB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.is_rad=get(hObject,'value');
if handles.is_rad;
    set(handles.deg_RB,'value',0);
    handles.angles.mult=1;
    handles=set_angles(handles);
else
    set(handles.deg_RB,'value',1);
    handles.angles.mult=180/pi;
    handles=set_angles(handles);
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of rad_RB



function sm_ET_Callback(hObject, eventdata, handles)
% hObject    handle to sm_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ap=str2num(get(handles.ap_ET,'string'))/handles.angles.mult;
am=(pi/2)-str2num(get(handles.sm_ET,'string'))/handles.angles.mult;
handles.angles.beta=ap+am;
handles.angles.delta=ap-am;
handles=set_angles(handles);
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of sm_ET as text
%        str2double(get(hObject,'String')) returns contents of sm_ET as a double


% --- Executes during object creation, after setting all properties.
function sm_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sm_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
%note: edit2 should have been sp_ET;
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ap=(pi/2)-str2num(get(handles.sp_ET,'string'))/handles.angles.mult;
if handles.is_symm
    am=ap;
else
    am=str2num(get(handles.am_ET,'string'))/handles.angles.mult;
end
handles.angles.beta=ap+am;
handles.angles.delta=ap-am;
handles=set_angles(handles);
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ap_ET_Callback(hObject, eventdata, handles)
% hObject    handle to ap_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ap=str2num(get(handles.ap_ET,'string'))/handles.angles.mult;
if handles.is_symm
    am=ap;
else
    am=str2num(get(handles.am_ET,'string'))/handles.angles.mult;
end
handles.angles.beta=ap+am;
handles.angles.delta=ap-am;
handles=set_angles(handles);
guidata(hObject,handles);


% Hints: get(hObject,'String') returns contents of ap_ET as text
%        str2double(get(hObject,'String')) returns contents of ap_ET as a double


% --- Executes during object creation, after setting all properties.
function ap_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ap_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function am_ET_Callback(hObject, eventdata, handles)
% hObject    handle to am_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ap=str2num(get(handles.ap_ET,'string'))/handles.angles.mult;
am=str2num(get(handles.am_ET,'string'))/handles.angles.mult;
handles.angles.beta=ap+am;
handles.angles.delta=ap-am;
handles=set_angles(handles);
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of am_ET as text
%        str2double(get(hObject,'String')) returns contents of am_ET as a double


% --- Executes during object creation, after setting all properties.
function am_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to am_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beta_ET_Callback(hObject, eventdata, handles)
% hObject    handle to beta_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.angles.beta=str2num(get(handles.beta_ET,'string'))/handles.angles.mult;
handles=set_angles(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beta_ET as text
%        str2double(get(hObject,'String')) returns contents of beta_ET as a double


% --- Executes during object creation, after setting all properties.
function beta_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function delta_ET_Callback(hObject, eventdata, handles)
% hObject    handle to delta_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.angles.delta=str2num(get(handles.delta_ET,'string'))/handles.angles.mult;
handles=set_angles(handles);
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of delta_ET as text
%        str2double(get(hObject,'String')) returns contents of delta_ET as a double


% --- Executes during object creation, after setting all properties.
function delta_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function gamma_ET_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.angles.gamma=str2num(get(handles.gamma_ET,'string'))/handles.angles.mult;
handles=set_angles(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of gamma_ET as text
%        str2double(get(hObject,'String')) returns contents of gamma_ET as a double


% --- Executes during object creation, after setting all properties.
function gamma_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function VR_ET_Callback(hObject, eventdata, handles)
% hObject    handle to VR_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.angles.VR=str2num(get(handles.VR_ET,'string'));
handles=set_angles(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of VR_ET as text
%        str2double(get(hObject,'String')) returns contents of VR_ET as a double


% --- Executes during object creation, after setting all properties.
function VR_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VR_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flow_CB.
function flow_CB_Callback(hObject, eventdata, handles)
% hObject    handle to flow_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flow_CB


% --- Executes on button press in time_CB.
function time_CB_Callback(hObject, eventdata, handles)
% hObject    handle to time_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of time_CB


% --- Executes on button press in rotation_CB.
function rotation_CB_Callback(hObject, eventdata, handles)
% hObject    handle to rotation_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotation_CB


% --- Executes on button press in velocity_CB.
function velocity_CB_Callback(hObject, eventdata, handles)
% hObject    handle to velocity_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of velocity_CB


% --- Executes on button press in stress_CB.
function stress_CB_Callback(hObject, eventdata, handles)
% hObject    handle to stress_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stress_CB


% --- Executes on button press in strain_CB.
function strain_CB_Callback(hObject, eventdata, handles)
% hObject    handle to strain_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of strain_CB



function fignum_ET_Callback(hObject, eventdata, handles)
% hObject    handle to fignum_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fignum_ET as text
%        str2double(get(hObject,'String')) returns contents of fignum_ET as a double
set(handles.fignum_ET,'value',...
    round(str2num(get(handles.fignum_ET,'string'))));

% --- Executes during object creation, after setting all properties.
function fignum_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fignum_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in update_PB.
function update_PB_Callback(hObject, eventdata, handles)
% hObject    handle to update_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ifig=get(handles.fignum_ET,'value');
nfig=handles.nfig;
if handles.nfig==0;
    handles.nfig=1;
    handles=initialize_figure(handles,1,ifig);
else
    imatch=find([handles.fig(:).ifig]==ifig);
    if isempty(imatch)
        imatch=handles.nfig+1;
        handles.nfig=imatch;
    end
    handles=initialize_figure(handles,imatch,ifig);
end
handles.fig(ifig).tag.flow=get(handles.flow_CB,'value');
handles.fig(ifig).tag.time=get(handles.time_CB,'value');
handles.fig(ifig).tag.velocity=get(handles.velocity_CB,'value');
handles.fig(ifig).tag.rotation=get(handles.rotation_CB,'value');
handles.fig(ifig).tag.stress=get(handles.stress_CB,'value');
handles.fig(ifig).tag.strain=get(handles.strain_CB,'value');
handles.fig(ifig).tag.geom=get(handles.geometry_CB,'value');

 handles.fig(ifig).Vtag=get(handles.V3D_RB,'Value')+...
     2*get(handles.Vtop_RB,'Value')+...
     3*get(handles.Vside_RB,'Value');

%handle.fig(ifig).hands=OAR_plot(handles.fig,handles.angles,handles.is_symm);
handle.fig(ifig).hands=OAR_plot(handles.fig,handles.angles,handles.is_symm);

guidata(hObject, handles);

% --- Executes on button press in options_PB.
function options_PB_Callback(hObject, eventdata, handles)
% hObject    handle to options_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in movie_PB.
function movie_PB_Callback(hObject, eventdata, handles)
% hObject    handle to movie_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M=180/pi;
ifig=get(handles.fignum_ET,'value'); %figure to print
if handles.is_symm
    Fname=sprintf('OAR_%g_S_%g_',...
        handles.angles.beta*M,...
        handles.angles.gamma*M);
else
    Fname=sprintf('OAR_%g_%g_%g_',...
        handles.angles.beta*M,...
        handles.angles.delta*M,...
        handles.angles.gamma*M);
end
Fname=[Fname,'_strain.avi'];
strain_movie(ifig,handles.angles,0.2,1,0.05,Fname,handles.is_symm);

% --- Executes on button press in print_PB.
function print_PB_Callback(hObject, eventdata, handles)
% hObject    handle to print_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M=180/pi;
ifig=get(handles.fignum_ET,'value'); %figure to print
if handles.is_symm
    Fname=sprintf('OAR_%g_S_%g_',...
        handles.angles.beta*M,...
        handles.angles.gamma*M);
else
    Fname=sprintf('OAR_%g_%g_%g_',...
        handles.angles.beta*M,...
        handles.angles.delta*M,...
        handles.angles.gamma*M);
end
if handles.fig(ifig).tag.flow
    Fname=[Fname,'F'];
end
if handles.fig(ifig).tag.time
    Fname=[Fname,'T'];
end
if handles.fig(ifig).tag.velocity
    Fname=[Fname,'V'];
end
if handles.fig(ifig).tag.rotation
    Fname=[Fname,'R'];
end
if handles.fig(ifig).tag.stress
    Fname=[Fname,'S'];
end
if handles.fig(ifig).tag.strain
    Fname=[Fname,'E'];
end
if handles.fig(ifig).tag.geom
    Fname=[Fname,'G'];
end
switch handles.fig(ifig).Vtag
    case 0
        Fname=[Fname,'_cross'];
    case 1
        Fname=[Fname,'_3D'];
    case 2 
        Fname=[Fname,'_top'];
    case 3
        Fname=[Fname,'_side'];
end
Fname=[Fname,'.tif'];
print(ifig,Fname,'-dtiff','-r300')

function handles=set_angles(handles);
% if handles.is_rad;
%     mult=1;
% else
%     mult=180/pi;
% end
mult=handles.angles.mult;
set(handles.beta_ET,'value',handles.angles.beta);
set(handles.beta_ET,'string',handles.angles.beta*mult);
set(handles.delta_ET,'value',handles.angles.delta);
set(handles.delta_ET,'string',handles.angles.delta*mult);
set(handles.gamma_ET,'value',handles.angles.gamma);
set(handles.gamma_ET,'string',handles.angles.gamma*mult);
set(handles.ap_ET,'value',...
    (handles.angles.beta+handles.angles.delta)/2);
set(handles.ap_ET,'string',...
    (handles.angles.beta+handles.angles.delta)*mult/2);
set(handles.am_ET,'value',...
    (handles.angles.beta-handles.angles.delta)/2);
set(handles.am_ET,'string',...
    (handles.angles.beta-handles.angles.delta)*mult/2);
set(handles.sp_ET,'value',...
    (pi-handles.angles.beta-handles.angles.delta)/2);
set(handles.sp_ET,'string',...beta
    (pi-handles.angles.beta-handles.angles.delta)*mult/2);
set(handles.sm_ET,'value',...
    (pi-handles.angles.beta+handles.angles.delta)/2);
set(handles.sm_ET,'string',...
    (pi-handles.angles.beta+handles.angles.delta)*mult/2);

%plot_lithosphere
axes(handles.X_plot)
cla
set(gca,'DataAspectRatio',[1,1,1])
ap=(handles.angles.beta+handles.angles.delta)/2;
if handles.is_symm
    if ap>pi/4
        fill([0,1,1,0],[0,0,1/tan(ap),0],[1,1,1]*0.8);
    else
        fill([0,1,1,tan(ap),0],[0,0,1,1,0],[1,1,1]*0.8);
    end
    hold on;
    plot([0,1,1,0,0],[0,0,1,1,0],'k');
    axis([-0.1,1.1,-0.1,1.1])
else
    am=(handles.angles.beta-handles.angles.delta)/2;
    if ap>pi/4
        if am>pi/4
            fill([-1,1,1,0,-1,-1],[0,0,1/tan(ap),0,1/tan(am),0],[1,1,1]*0.8);
        else
            fill([-1,1,1,0,-tan(am),-1,-1],[0,0,1/tan(ap),0,1,1,0],[1,1,1]*0.8);
        end
    else
        if am>pi/4
            fill([-1,1,1,tan(ap),0,-1,-1],[0,0,1,1,0,1/tan(am),0],[1,1,1]*0.8);
        else
            fill([-1,1,1,tan(ap),0,-tan(am),-1,-1],[0,0,1,1,0,1,1,0],[1,1,1]*0.8);
        end
    end
    hold on;
    plot([-1,1,1,-1,-1],[0,0,1,1,0],'k');
    
    axis([-1.1,1.1,-0.1,1.1])
end
set(gca,'ydir','reverse');

%plot velocity plot
axes(handles.V_plot);
cla;
hold on;
%plot plate velocity
plot([-1,1],[0,0],'o-k','markersize',10);
%plot(ridge orientation
gamma=handles.angles.gamma;
sep=0.025;
VR=handles.angles.VR;
plot(VR+sep*cos(gamma)+[1,-1]*sin(gamma),...
    -sep*sin(gamma)+[1,-1]*cos(gamma),'k')
plot(VR-sep*cos(gamma)+[1,-1]*sin(gamma),...
    sep*sin(gamma)+[1,-1]*cos(gamma),'k')
VPl=1-VR;
h=VPl*sin(gamma)*cos(gamma);
x1=VPl*sin(gamma)^2;x2=VPl*cos(gamma)^2;
quiver([0,x1]+VR,[0,h],...
    [x1,x2],[h,-h],0,...
    'k','linewidth',2)
VPm=-1-VR;
h=VPm*sin(gamma)*cos(gamma);
x1=VPm*sin(gamma)^2;x2=VPm*cos(gamma)^2;
quiver([0,x1]+VR,[0,h],...
    [x1,x2],[h,-h],0,...
    'k','linewidth',2)
set(handles.V_plot,'Dataaspectratio',[1,1,1],'box','on');
axis([-1,1,-1,1]*1.1);


%A=-VR+VE*((b*cos(b)+sin(b))*sin(d)-d*(b+sin(b)*cos(d)))/(b^2-sin(b)^2);
%B=-VE*((b+sin(b)*cos(d))*(1+cos(b)*cos(d))+(d+cos(b)*sin(d))*sin(b)*sin(d))/(b^2-sin(b)^2);
%C=2*VE*(b+sin(b)*cos(d))/(b^2-sin(b)^2);
%D=2*VE*sin(b)*sin(d)/(b^2-sin(b)^2);
b=handles.angles.beta;
d=handles.angles.delta;
VE=cos(handles.angles.gamma);

handles.angles.A=-VR+VE*((b*cos(b)+sin(b))*sin(d)-d*(b+sin(b)*cos(d)))/(b^2-sin(b)^2);
handles.angles.B=-VE*((b+sin(b)*cos(d))*(1+cos(b)*cos(d))+(d+cos(b)*sin(d))*sin(b)*sin(d))/(b^2-sin(b)^2);
handles.angles.C=2*VE*(b+sin(b)*cos(d))/(b^2-sin(b)^2);
handles.angles.D=2*VE*sin(b)*sin(d)/(b^2-sin(b)^2);

% --- Executes on button press in geometry_CB.
function geometry_CB_Callback(hObject, eventdata, handles)
% hObject    handle to geometry_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of geometry_CB


function handles=initialize_figure(handles,nfig,ifig)
figure(ifig);
clf;
%setup sampling points
nzs=7;
zmin=0.0;zmax=1;
xmax=1;
thmax=(handles.angles.beta+handles.angles.delta)/2; %ap
if handles.is_symm
    nxs=nzs;
    xmin=0;
    thmin=0;
else
    nxs=2*nzs;
    xmin=-xmax;    
    thmin=-(handles.angles.beta-handles.angles.delta)/2; %am
end
xb=linspace(xmin,xmax,2*nxs);
zb=xb*0+1;
[xs,zs]=meshgrid(linspace(xmin,xmax,nxs),linspace(zmin,zmax,nzs));
[xst,zst]=meshgrid(linspace(xmin,xmax,nxs*100),linspace(zmin,zmax,nzs*100));
xbt=linspace(xmin,xmax,100);
zbt=xbt*0+1;
handles.fig(nfig).tsamp=0:0.01:5;
handles.fig(nfig).ifig=ifig;
handles.fig(nfig).xb=xb;
handles.fig(nfig).zb=zb;
handles.fig(nfig).xbt=xbt;
handles.fig(nfig).zbt=zbt;
handles.fig(nfig).xs=xs;
handles.fig(nfig).zs=zs;
handles.fig(nfig).xst=xst;
handles.fig(nfig).zst=zst;
handles.fig(nfig).thmin=thmin;
handles.fig(nfig).thmax=thmax;

handles.fig(nfig).hands=[];

set(handles.print_PB,'enable','on')
set(handles.movie_PB,'enable','on')


% --- Executes on button press in delete_PB.
function delete_PB_Callback(hObject, eventdata, handles)
% hObject    handle to delete_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.nfig~=0;
    imatch=find([handles.fig(:).ifig]==...
        get(handles.fignum_ET,'value'));
    if ~isempty(imatch)
        close(handles.fig(imatch).ifig)
        for ifig=imatch:handles.nfig-1
            handles.fig(ifig)=handles.fig(ifig+1);
        end
        handles.fig(handles.nfig)=[];
    end
end
            




