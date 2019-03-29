function varargout = assignment(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @assignment_OpeningFcn, ...
                   'gui_OutputFcn',  @assignment_OutputFcn, ...
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


function assignment_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
list_male_freq = []
list_female_freq = []
data =  dir('female/*wav');
for i = 1: length(data)
    file = fullfile('C:\Users\giang\Documents\MATLAB\female\',data(i).name);
    [y,Fs] = audioread(file);
    Y = fft(y);
    L = length(y);
    P1 = Y(1:L/2+1);
    psd = (1/(Fs*L)) * abs(P1).^2;
    psd(2:end-1) = 2*psd(2:end-1);
    freq =0:Fs/L: Fs/2;
    freq = freq(300*L/Fs: 3400*L/Fs);
    psd = 10*log10(psd);
    psd = psd(300*L/Fs: 3400*L/Fs); 
    [maxval, index] = max(psd);
    list_female_freq = [list_female_freq,freq(index) ];
    
end
data =  dir('male/*wav');
for i = 1: length(data)
    file = fullfile('C:\Users\giang\Documents\MATLAB\male\',data(i).name);
    [y,Fs] = audioread(file);
    Y = fft(y);
    L = length(y);
    P1 = Y(1:L/2+1);
    psd = (1/(Fs*L)) * abs(P1).^2;
    psd(2:end-1) = 2*psd(2:end-1);
    freq = 0:Fs/L:Fs/2;
    freq = freq(300*L/Fs: 3400*L/Fs);
    psd = 10*log10(psd);
    psd = psd(300*L/Fs: 3400*L/Fs);
    [maxval, index] = max(psd);
    list_male_freq = [list_male_freq,freq(index) ];
end

global data_set
data_set = horzcat(list_male_freq, list_female_freq );
global target_set 
target_set = horzcat(zeros(1,length(list_male_freq)), ones(1,length(list_female_freq)));

function varargout = assignment_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
function pushbutton1_Callback(hObject, eventdata, handles)
global data_set
global target_set
[file, path] = uigetfile('*.wav');
set(handles.file_local,'String', strcat(path,file));
[y,Fs] = audioread(get(handles.file_local,'String' ));      
Y = fft(y);
L = length(y);
P1 = Y(1:L/2+1);
psd = (1/(Fs*L)) * abs(P1).^2;
psd(2:end-1) = 2*psd(2:end-1);
freq = 0:Fs/L:Fs/2;
freq = freq(300*L/Fs: 3400*L/Fs);
psd = 10*log10(psd);
psd = psd(300*L/Fs: 3400*L/Fs);
[maxval, index] = max(psd);
plot(freq,psd);
freq_process = freq(index);

%knn
distance = (data_set - freq_process).^2;
[val ind] = sort(distance,'descend');
target_k =  target_set(ind(1:3));
if(length(target_k(target_k == 1)) > length(target_k(target_k == 0)))
    set(handles.text1,'String','male');
else
    set(handles.text1,'String','female');
end

function file_local_Callback(hObject, eventdata, handles)
function file_local_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
