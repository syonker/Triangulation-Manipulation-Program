%Name: 
%    finElements
%
%Purpose:
%    This is the secondary gui which opens when the user clicks apply
%    forces in triangulateGUI. This will allow the user to use the finite
%    element method on their custom shape and save images and videos of
%    their results.
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function varargout = finElements(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @finElements_OpeningFcn, ...
                   'gui_OutputFcn',  @finElements_OutputFcn, ...
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


% --- Executes just before finElements is made visible.
function finElements_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to finElements (see VARARGIN)
global T;
global V;
global Vbound;
global xMin;
global xMax;
global yMin;
global yMax;
global ogPlot;
global ogPlotToggle;
global movedPlotToggle;
global forceFunc;
global boundPoints;
global forcePoints;
global minDistance;
global allBound;
global allForce;
global loadingOn;
global loadingOff;
global saving;
global forcePointsOn;
global boundOn;
global fIndex;

path(path,'supportFiles\triangulation');
path(path,'supportFiles\plotting');
path(path,'supportFiles\plotting\export_fig');
path(path,'supportFiles\finElements');
path(path,'customFunctions');
path(path,'supportFiles/triangulation');
path(path,'supportFiles/plotting');
path(path,'supportFiles/plotting/export_fig');
path(path,'supportFiles/finElements');

loadingOn = sprintf('L\nO\nA\nD\n I\nN\nG\n *\n\n *\n\n *\n *\n *\n\n *\n\n *\nL\nO\nA\nD\n I\nN\nG');
loadingOff = ' ';
saving = sprintf('\nS\nA\nV\n I\nN\nG\n *\n\n *\n\n *\n *\n *\n\n *\n\n *\nS\nA\nV\n I\nN\nG\n');

set(handles.text22,'String',loadingOff);

allBound = 0;
allForce = 0;

boundPoints = 0;
forcePoints = 0;

forcePointsOn = 1;
boundOn = 1;

forceFunc = cell(11,1);
forceFunc{1} = @fNothing;
forceFunc{2} = @fUp;
forceFunc{3} = @fDown;
forceFunc{4} = @fLeft;
forceFunc{5} = @fRight;
forceFunc{6} = @fHorzPinch;
forceFunc{7} = @fVertPinch;
forceFunc{8} = @fOut;
forceFunc{9} = @fIn;
forceFunc{10} = @fSpin;
forceFunc{11} = @fCustom;

fIndex = 1;

%gets error treshhold by finding smallest line in figure
minDistance = [abs(xMax-xMin),0];

for i=1:size(T,1)
    
    for j=1:3
        
        if (j==3)
            p=1;
        else
            p=j+1;
        end
        
        d = pdist([V(T(i,j),1),V(T(i,j),2);V(T(i,p),1),V(T(i,p),2)],'euclidean');
        
        if (d < minDistance(1,1))
            
            minDistance(1,1) = d;
            
        end
        
    end
    
end

set(handles.edit1, 'String', num2str(xMin));
set(handles.edit4, 'String', num2str(xMax));
set(handles.edit2, 'String', num2str(yMin));
set(handles.edit5, 'String', num2str(yMax));

%Set default instructions
set(handles.text16, 'String', 'Select boundary and force points, choose a force function and constant, and hit GO!');


% Choose default command line output for finElements
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

Vbound = zeros(size(V,1),4);
Vbound(:,1:2) = V(:,1:2);

ogPlot = plot2d(T,V);
ogPlotToggle = 1;
movedPlotToggle = 0;


% --- Outputs from this function are returned to the command line.
function varargout = finElements_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global xMin;
global xMax;
global yMin;
global yMax;
global axisOn;

axis([xMin,xMax,yMin,yMax]);
hold on;

ax = gca;
ax.XColor = 'blue';
ax.YColor = 'blue';
ax.XLim = [xMin xMax];
ax.YLim = [yMin yMax];

if (axisOn == 0)
      
   set(gca,'xcolor','white');
   set(gca,'ycolor','white');
    
end


%SELECT FORCE POINTS
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vbound;
global forcePointsOn;
global movedPlotToggle;
global forcePoints;
global boundPoints;
global boundOn;

if (movedPlotToggle)
   
    uiwait(msgbox({'Reset Mesh!' 'Before altering the force points you must reset the mesh.'}, ...
        'Cannot Change Force Points','error','modal'));
   
    return;
    
end

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', sprintf('Click the points on the mesh which you would like the force to be applied to.\n                 Hit the enter key when you are finished.'));

finished = 0;

while (~finished)

[x,y] = ginput(1);

%check to see if enter wasnt clicked
if (x)
    
    min = pdist([Vbound(1,1:2);x,y],'euclidean');
    minV = 1;
    
    %find closest vertex
    for i=2:size(Vbound,1)
        
        dist = pdist([Vbound(i,1:2);x,y],'euclidean');
        
        if (dist < min)
            
            minV = i;
            min = dist;
            
        end
        
    end
    
    %if it is not already a part of the force points
    if (Vbound(minV,3) ~= 2)
        
        if (Vbound(minV,3) == 1)
            
            delete(Vbound(minV,4));
            boundPoints = boundPoints - 1; 
            
        end
        
        Vbound(minV,3) = 2;
        Vbound(minV,4) = scatter(Vbound(minV,1),Vbound(minV,2),'MarkerEdgeColor','k','MarkerFaceColor','g');
        
        if (~forcePointsOn)
            
            set(Vbound(minV,4),'Visible','off');
            
        end
        forcePoints = forcePoints + 1;
        
    else
        
        Vbound(minV,3) = 0;
        delete(Vbound(minV,4));
        forcePoints = forcePoints - 1;
        
    end
 
%if enter was clicked
else
    
    finished = 1;
    
    
end


end

%Reset instructions
set(handles.text16, 'String', prevInstructions);



%SELECT BOUNDARY
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vbound;
global boundOn;
global movedPlotToggle;
global boundPoints;
global forcePoints;

if (movedPlotToggle)
   
    uiwait(msgbox({'Reset Mesh!' 'Before altering the boundary conditions you must reset the mesh.'}, ...
        'Cannot Change Boundary Points','error','modal'));
   
    return;
    
end

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', sprintf('Click the points on the mesh which you would like to be fixed.\n              Hit the enter key when you are finished.'));

finished = 0;

while (~finished)

[x,y] = ginput(1);

%check to see if enter wasnt clicked
if (x)
    
    min = pdist([Vbound(1,1:2);x,y],'euclidean');
    minV = 1;
    
    %find closest vertex
    for i=2:size(Vbound,1)
        
        dist = pdist([Vbound(i,1:2);x,y],'euclidean');
        
        if (dist < min)
            
            minV = i;
            min = dist;
            
        end
        
    end
    
    %if it is not already a part of the boundary
    if (Vbound(minV,3) ~= 1)
        
        if (Vbound(minV,3) == 2)
            
            delete(Vbound(minV,4));
            forcePoints = forcePoints - 1; 
            
        end
        
        Vbound(minV,3) = 1;
        Vbound(minV,4) = scatter(Vbound(minV,1),Vbound(minV,2),'s','MarkerEdgeColor','k','MarkerFaceColor','r');
        if (~boundOn)
            set(Vbound(minV,4),'Visible','off');           
        end
        boundPoints = boundPoints + 1;
        
    else
        
        Vbound(minV,3) = 0;
        delete(Vbound(minV,4));
        boundPoints = boundPoints - 1;
        
    end
 
%if enter was clicked
else
    
    finished = 1;
    
    
end

end

%Reset instructions
set(handles.text16, 'String', prevInstructions);




%GOOOOOO!
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global V;
global T;
global u;
global Vbound;
global ogPlot;
global ogPlotToggle;
global movedPlot;
global constant;
global movedPlotToggle;
global forceFunc;
global fIndex;
global boundPoints;
global forcePoints;
global origin;
global xMin;
global xMax;
global yMin;
global yMax;
global custFunc;
global loadingOn;
global loadingOff;
global forcePointsOn;
global boundOn;

if (boundPoints < 2)
    
    uiwait(msgbox({'Before applying the force function you must have at least two Dirichlet boundary points chosen.'}, ...
        'Need more boundary conditions!','error','modal'));
    
    return;
    
end

if (forcePoints == 0)
    
    uiwait(msgbox({'Before applying the force function you must have at least one point chosen to be affected by it.'}, ...
        'No Force Points Selected!','error','modal'));
    
    return;
    
end

if (fIndex == 1)

    uiwait(msgbox({'You must choose which force function you would like to apply.'}, ...
        'No Force Function Selected!','error','modal'));
    
    return;
    
end

if (fIndex == 11)
    
    fname = get(handles.edit6, 'String');
    
    cd customFunctions;
    
    if (isempty(dir(strcat(fname,'.m'))))
        
        cd ..;
        
        uiwait(msgbox({'Your custom function name does not match that of any existing functions in the customFunctions folder.'}, ...
        'Invalid Custom Function!','error','modal'));
        
        return;
        
    end
    
    cd ..;

    custFunc = str2func(fname);
    
end


set(handles.text22,'String',loadingOn);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

origin = [xMin+((xMax-xMin)/2),yMin+((yMax-yMin)/2)];


constant = str2num(get(handles.const, 'String'));


[A,F]=makeAandF(V,T,forceFunc{fIndex});

u=getu(A,F,Vbound(:,1:3));

if (movedPlotToggle)
    
    delete(movedPlot);
    
else

    set(ogPlot,'Visible','off');
    ogPlotToggle = 0;
    
end

movedPlot = plot2dwithu(T,V,constant*u);

movedPlotToggle = 1;

b = size(Vbound,1);

for i=1:b
    
    if (Vbound(i,3) == 2)
        
        delete(Vbound(i,4));
        Vbound(i,4) = scatter(Vbound(i,1)+constant*u(i),Vbound(i,2)+constant*u(i+b),'MarkerEdgeColor','k','MarkerFaceColor','g');

        if (~forcePointsOn)
            set(Vbound(i,4),'Visible','off');
        end
        
    elseif (Vbound(i,3) == 1)
        
        delete(Vbound(i,4));
        Vbound(i,4) = scatter(Vbound(i,1)+constant*u(i),Vbound(i,2)+constant*u(i+b),'s','MarkerEdgeColor','k','MarkerFaceColor','r');

        if (~boundOn)
            set(Vbound(i,4),'Visible','off');
        end
    end
    
end

set(handles.text22,'String',loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);


%NEW ORIGIN
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xMin;
global xMax;
global yMin;
global yMax;
global loadingOn;
global loadingOff;


%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', 'Click on the graph where you would like the new center to be.');

%get the button click for the new origin
[x,y] = ginput(1);

set(handles.text22,'String',loadingOn);

drawnow;

%Reset instructions
set(handles.text16, 'String', prevInstructions);

   %maintain the current zoom
   xMin = (x -((xMax-xMin)/2));
   xMax = (x +((xMax-xMin)/2));
   yMin = (y -((yMax-yMin)/2));
   yMax = (y +((yMax-yMin)/2));

   %change the axis
   axis([xMin,xMax,yMin,yMax]);
   
   set(handles.edit1, 'String', num2str(xMin));
   set(handles.edit4, 'String', num2str(xMax));
   set(handles.edit2, 'String', num2str(yMin));
   set(handles.edit5, 'String', num2str(yMax));
   
set(handles.text22,'String',loadingOff);



%ZOOM IN
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xMin;
global xMax;
global yMin;
global yMax;


distX=(xMax-xMin)/4;
distY=(yMax-yMin)/4;
midX = (xMax+xMin)/2;
midY = (yMax+yMin)/2;

xMin = midX-distX;
xMax = midX+distX;
yMin = midY-distY;
yMax = midY+distY;

axis([xMin,xMax,yMin,yMax]);

set(handles.edit1, 'String', num2str(xMin));
set(handles.edit4, 'String', num2str(xMax));
set(handles.edit2, 'String', num2str(yMin));
set(handles.edit5, 'String', num2str(yMax));


%ZOOM OUT
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xMin;
global xMax;
global yMin;
global yMax;

distX=(xMax-xMin)/2;
distY=(yMax-yMin)/2;

xMin = xMin-distX;
xMax = xMax+distX;
yMin = yMin-distY;
yMax = yMax+distY;

axis([xMin,xMax,yMin,yMax]);

set(handles.edit1, 'String', num2str(xMin));
set(handles.edit4, 'String', num2str(xMax));
set(handles.edit2, 'String', num2str(yMin));
set(handles.edit5, 'String', num2str(yMax));



%XMIN BOX
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%YMIN BOX
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%SET AXIS
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xMin;
global xMax;
global yMin;
global yMax;


xMin2 = str2num(get(handles.edit1, 'String'));
xMax2 = str2num(get(handles.edit4, 'String'));
yMin2 = str2num(get(handles.edit2, 'String'));
yMax2 = str2num(get(handles.edit5, 'String'));

if ((xMin2>=xMax2) || (yMin2>=yMax2))
    
    uiwait(msgbox({'Invalid Value!' 'Min must be less than Max'}, 'Incorrect Axis','error','modal'));
    
else

    xMin = xMin2;
    xMax = xMax2;
    yMin = yMin2;
    yMax = yMax2;

    axis([xMin,xMax,yMin,yMax]);
    
end


%XMAX BOX
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%YMAX BOX
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%CONST BOX
function const_Callback(hObject, eventdata, handles)
% hObject    handle to const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function const_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%AXIS ON/OFF
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global axisOn

if (axisOn == 1)
    
    set(gca,'xcolor','white');
    set(gca,'ycolor','white');
    
    axisOn = 0;
    
else
    
    ax = gca;
    ax.XColor = 'blue';
    ax.YColor = 'blue';
    
    axisOn = 1;
    
end

%INSTRUCTIONS
% --- Executes during object creation, after setting all properties.
function text16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



%RESET
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vbound;
global ogPlot;
global ogPlotToggle;
global movedPlot;
global movedPlotToggle;
global loadingOn;
global loadingOff;
global forcePointsOn;


if (ogPlotToggle)
    
    return;
    
else
    
set(handles.text22,'String',loadingOn);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

delete(movedPlot);
movedPlotToggle = 0;

set(ogPlot,'Visible','on');
ogPlotToggle = 1;

for i=1:size(Vbound,1)
    
    if (Vbound(i,3) == 2)
        
        delete(Vbound(i,4));
        Vbound(i,4) = scatter(Vbound(i,1),Vbound(i,2),'MarkerEdgeColor','k','MarkerFaceColor','g');

        if (~forcePointsOn)
            set(Vbound(i,4),'Visible','off');
        end
    end
    
end

end

set(handles.text22,'String',loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);


%SHOW/HIDE BOUNDARY
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vbound;
global boundOn;


if (boundOn)
    
    for i=1:size(Vbound,1)
    
        if (Vbound(i,3) == 1)
        
            set(Vbound(i,4),'Visible','off');
            
        end
        
    end
    
    boundOn = 0;
    
else
    
    for i=1:size(Vbound,1)
    
        if (Vbound(i,3) == 1)
        
            set(Vbound(i,4),'Visible','on');
            
        end
        
    end
    
    boundOn = 1;
    
end


%FORCE POINTS ON/OFF
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vbound;
global forcePointsOn;


if (forcePointsOn)
    
    for i=1:size(Vbound,1)
    
        if (Vbound(i,3) == 2)
        
            set(Vbound(i,4),'Visible','off');
            
        end
        
    end
    
    forcePointsOn = 0;
    
else
    
    for i=1:size(Vbound,1)
    
        if (Vbound(i,3) == 2)
        
            set(Vbound(i,4),'Visible','on');
            
        end
        
    end
    
    forcePointsOn = 1;
    
end      
        

%FORCE FUNCTION SELECTION BOX
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fIndex;

% Determine the selected force function.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
case 'Select a 2D Force Function'
   fIndex = 1;
case 'Up'
   fIndex = 2;
case 'Down'
   fIndex = 3;
case 'Left'
   fIndex = 4;
case 'Right'
   fIndex = 5;
case 'Horizontal Pinch'
   fIndex = 6;
case 'Vertical Pinch'
   fIndex = 7;
case 'Away from Origin'
   fIndex = 8;
case 'Towards the Origin'
   fIndex = 9;
case 'Spin'
   fIndex = 10;
case 'Custom'
   fIndex = 11;
end




% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%MAKE ALL BOUNDARY
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vbound;
global forcePoints;
global boundPoints;
global allBound;
global loadingOn;
global loadingOff;
global boundOn;

set(handles.text22,'String',loadingOn);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

if (~allBound)

    for i=1:size(Vbound,1)

        %if it is not already a part of the boundary
        if (Vbound(i,3) == 0)

            Vbound(i,3) = 1;
            Vbound(i,4) = scatter(Vbound(i,1),Vbound(i,2),'s','MarkerEdgeColor','k','MarkerFaceColor','r');
            if (~boundOn)
                set(Vbound(i,4),'Visible','off');
            end
            boundPoints = boundPoints + 1;

        end

    end
    
    allBound = 1;

else
    
    for i=1:size(Vbound,1)

        %if its is a part of the boundary
        if (Vbound(i,3) == 1)

            delete(Vbound(i,4));
            Vbound(i,3) = 0;
            boundPoints = boundPoints - 1;

        end

    end
    
    allBound = 0;
    
end
    
set(handles.text22,'String',loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);
        



%MAKE ALL FORCE
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vbound;
global forcePoints;
global allForce;
global loadingOn;
global loadingOff;
global forcePointsOn;

set(handles.text22,'String',loadingOn);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

if (~allForce)

    for i=1:size(Vbound,1)

        %if it is not already a part of the force points
        if (Vbound(i,3) == 0)

            Vbound(i,3) = 2;
            Vbound(i,4) = scatter(Vbound(i,1),Vbound(i,2),'MarkerEdgeColor','k','MarkerFaceColor','g');
            if (~forcePointsOn)
                set(Vbound(i,4),'Visible','off');
            end
            forcePoints = forcePoints + 1;

        end

    end
    
    allForce = 1;

else
    
    for i=1:size(Vbound,1)

        %if its is a part of the force points
        if (Vbound(i,3) == 2)

            delete(Vbound(i,4));
            Vbound(i,3) = 0;
            forcePoints = forcePoints - 1;

        end

    end
    
    allForce = 0;
    
end

set(handles.text22,'String',loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);


%SAVE IMG
% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global saving;
global loadingOff;

set(handles.text22,'String',saving);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

filename = get(handles.edit14, 'String');

if (isempty(filename))
    
    filename = 'untitled';
    
end

ax = gca;

cd saveFiles;
fpath = pwd;
cd ..;

fullName = fullfile(fpath,filename);
export_fig(ax,fullName,'-jpg');

set(handles.text22,'String',loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);


%SAVE VIDEO
% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global V;
global T;
global u;
global Vbound;
global ogPlot;
global ogPlotToggle;
global movedPlot;
global constantVideo;
global movedPlotToggle;
global forceFunc;
global fIndex;
global boundPoints;
global forcePoints;
global origin;
global xMin;
global xMax;
global yMin;
global yMax;
global custFunc;
global saving;
global loadingOff;
global forcePointsOn;
global boundOn;
    

if (boundPoints < 2)
    
    uiwait(msgbox({'Before applying the force function you must have at least two Dirichlet boundary points chosen.'}, ...
        'Need more boundary conditions!','error','modal'));
    
    return;
    
end

if (forcePoints == 0)
    
    uiwait(msgbox({'Before applying the force function you must have at least one point chosen to be affected by it.'}, ...
        'No Force Points Selected!','error','modal'));
    
    return;
    
end

numSteps = str2num(get(handles.edit13, 'String'));

if (numSteps <= 1)
    
    uiwait(msgbox({'In order to make a video you must have at least two steps.'}, ...
        'Not Enough Steps!','error','modal'));
    
    return;
    
end

if (fIndex == 1)

    uiwait(msgbox({'You must choose which force function you would like to apply.'}, ...
        'No Force Function Selected!','error','modal'));
    
    return;
    
end

if (fIndex == 11)
    
    fname = get(handles.edit6, 'String');
    
    cd customFunctions;
    
    if (isempty(dir(strcat(fname,'.m'))))
        
        cd ..;
        
        uiwait(msgbox({'Your custom function name does not match that of any existing functions in the customFunctions folder.'}, ...
        'Invalid Custom Function!','error','modal'));
        
        return;
        
    end
    
    cd ..;

    custFunc = str2func(fname);
    
end

set(handles.text22,'String',saving);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

filename = get(handles.edit14, 'String');

if (isempty(filename))
    
    filename = 'untitled';
    
end

cd saveFiles;
mkdir(filename);
cd(filename);
fpath = pwd;
cd ..;
cd ..;

origin = [xMin+((xMax-xMin)/2),yMin+((yMax-yMin)/2)];


constantVideo = str2num(get(handles.edit12, 'String'));


[A,F]=makeAandF(V,T,forceFunc{fIndex});

u=getu(A,F,Vbound(:,1:3));

b = size(Vbound,1);

counter = 0;

for z=constantVideo:constantVideo:(constantVideo*numSteps)
    
counter = counter + 1;

saveProgress1 = sprintf('\nS\nA\nV\n I\nN\nG\n *\n\n *\n\n *\n-');
saveProgress2 = num2str(counter);
saveProgress3 = sprintf('-\n *\n\n *\n\n *\nS\nA\nV\n I\nN\nG\n');
saveProgress = strcat(saveProgress1,saveProgress2,saveProgress3);
set(handles.text22,'String',saveProgress);
drawnow;
    
if (movedPlotToggle)
    
    delete(movedPlot);
    
else

    set(ogPlot,'Visible','off');
    ogPlotToggle = 0;
    
end

movedPlot = plot2dwithu(T,V,z*u);

movedPlotToggle = 1;

for i=1:b
    
    if (Vbound(i,3) == 2)
        
        delete(Vbound(i,4));
        Vbound(i,4) = scatter(Vbound(i,1)+z*u(i),Vbound(i,2)+z*u(i+b),'MarkerEdgeColor','k','MarkerFaceColor','g');
        
        if (~forcePointsOn)
            set(Vbound(i,4),'Visible','off');
        end
        
    elseif (Vbound(i,3) == 1)
        
        delete(Vbound(i,4));
        Vbound(i,4) = scatter(Vbound(i,1),Vbound(i,2),'s','MarkerEdgeColor','k','MarkerFaceColor','r');
        if (~boundOn)
            set(Vbound(i,4),'Visible','off');
        end
    end
    
end

drawnow;


%save current image
ax = gca;

fullName = fullfile(fpath,strcat(filename,num2str(counter)));
export_fig(ax,fullName,'-jpg','-painters');

fullName = fullfile(fpath,filename);
export_fig(ax,fullName,'-tif','-nocrop','-append','-painters');

end

im2gif(strcat(fullName,'.tif'),strcat(fullName,'.gif'),'-delay',.3);
temp = strcat(fullName,'.tif');
delete(temp);

set(handles.text22,'String',loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);



%VIDEO CONSTANT
function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%NUM OF STEPS
function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%VIDEO GO
% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global V;
global T;
global u;
global Vbound;
global ogPlot;
global ogPlotToggle;
global movedPlot;
global constantVideo;
global movedPlotToggle;
global forceFunc;
global fIndex;
global boundPoints;
global forcePoints;
global origin;
global xMin;
global xMax;
global yMin;
global yMax;
global custFunc;
global loadingOn;
global loadingOff;
global forcePointsOn;
global boundOn;
    


if (boundPoints < 2)
    
    uiwait(msgbox({'Before applying the force function you must have at least two Dirichlet boundary points chosen.'}, ...
        'Need more boundary conditions!','error','modal'));
    
    return;
    
end

if (forcePoints == 0)
    
    uiwait(msgbox({'Before applying the force function you must have at least one point chosen to be affected by it.'}, ...
        'No Force Points Selected!','error','modal'));
    
    return;
    
end

numSteps = str2num(get(handles.edit13, 'String'));

if (numSteps <= 1)
    
    uiwait(msgbox({'In order to make a video you must have at least two steps.'}, ...
        'Not Enough Steps!','error','modal'));
    
    return;
    
end

if (fIndex == 1)

    uiwait(msgbox({'You must choose which force function you would like to apply.'}, ...
        'No Force Function Selected!','error','modal'));
    
    return;
    
end

if (fIndex == 11)
    
    fname = get(handles.edit6, 'String');
    
    cd customFunctions;
    
    if (isempty(dir(strcat(fname,'.m'))))
        
        cd ..;
        
        uiwait(msgbox({'Your custom function name does not match that of any existing functions in the customFunctions folder.'}, ...
        'Invalid Custom Function!','error','modal'));
        
        return;
        
    end
    
    cd ..;

    custFunc = str2func(fname);
    
end

set(handles.text22,'String',loadingOn);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

origin = [xMin+((xMax-xMin)/2),yMin+((yMax-yMin)/2)];


constantVideo = str2num(get(handles.edit12, 'String'));


[A,F]=makeAandF(V,T,forceFunc{fIndex});

u=getu(A,F,Vbound(:,1:3));



b = size(Vbound,1);


for z=constantVideo:constantVideo:(constantVideo*numSteps)
    
    
if (movedPlotToggle)
    
    delete(movedPlot);
    
else

    set(ogPlot,'Visible','off');
    ogPlotToggle = 0;
    
end

movedPlot = plot2dwithu(T,V,z*u);

movedPlotToggle = 1;

for i=1:b
    
    if (Vbound(i,3) == 2)
        
        delete(Vbound(i,4));
        Vbound(i,4) = scatter(Vbound(i,1)+z*u(i),Vbound(i,2)+z*u(i+b),'MarkerEdgeColor','k','MarkerFaceColor','g');

        if (~forcePointsOn)
            set(Vbound(i,4),'Visible','off');
        end
        
    elseif (Vbound(i,3) == 1)
        
        delete(Vbound(i,4));
        Vbound(i,4) = scatter(Vbound(i,1)+z*u(i),Vbound(i,2)+z*u(i+b),'s','MarkerEdgeColor','k','MarkerFaceColor','r');

        if (~boundOn)
            set(Vbound(i,4),'Visible','off');
        end
    end
    
end

drawnow;

end

set(handles.text22,'String',loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);




%VIDEO RESET
% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Vbound;
global ogPlot;
global ogPlotToggle;
global movedPlot;
global movedPlotToggle;
global loadingOn;
global loadingOff;
global forcePointsOn;


if (ogPlotToggle)
    
    return;
    
else
    
set(handles.text22,'String',loadingOn);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

delete(movedPlot);
movedPlotToggle = 0;

set(ogPlot,'Visible','on');
ogPlotToggle = 1;

for i=1:size(Vbound,1)
    
    if (Vbound(i,3) == 2)
        
        delete(Vbound(i,4));
        Vbound(i,4) = scatter(Vbound(i,1),Vbound(i,2),'MarkerEdgeColor','k','MarkerFaceColor','g');

        if (~forcePointsOn)
            set(Vbound(i,4),'Visible','off');
        end
    end
    
end

end

set(handles.text22,'String',loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);

%LOADING TEXT
% --- Executes during object creation, after setting all properties.
function text22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%NAME
function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%-----------------------------------------FUNCTIONS------------------------
function[y] = fNothing(x1,x2)

y=[0;0];

function[y] = fUp(x1,x2)
global Vbound;
global minDistance;
global constant;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
            y=[0;constant*.1];
            return;
            
        end
        
    end

end

function[y] = fDown(x1,x2)
global Vbound;
global minDistance;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
            y=[0;-.1];
            return;
            
        end
        
    end

end

function[y] = fLeft(x1,x2)
global Vbound;
global minDistance;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
            y=[-.1;0];
            return;
            
        end
        
    end

end

function[y] = fRight(x1,x2)
global Vbound;
global minDistance;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
            y=[.1;0];
            return;
            
        end
        
    end

end

function[y] = fHorzPinch(x1,x2)
global Vbound;
global minDistance;
global origin;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
            if (x1 > origin(1,1))
                
                y=[-.1;0];
                
            elseif (x1 < origin(1,1))
                
                y=[.1;0];
            
            end
            return;
            
        end
        
    end

end

function[y] = fVertPinch(x1,x2)
global Vbound;
global minDistance;
global origin;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
            if (x2 > origin(1,2))
                
                y=[0;-.1];
                
            elseif (x2 < origin(1,2))
                
                y=[0;.1];
            
            end
            return;
            
        end
        
    end

end

function[y] = fOut(x1,x2)
global Vbound;
global minDistance;
global origin;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
            mag = (1/((x1-origin(1))^(2) + (x2-origin(2))^(2) + .01));
   
            y = [mag*(x1-origin(1));mag*(x2-origin(2))];

            return;
            
        end
        
    end

end

function[y] = fIn(x1,x2)
global Vbound;
global minDistance;
global origin;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
            mag = (1/((x1-origin(1))^(2) + (x2-origin(2))^(2) + .01));
   
            y = [-mag*(x1-origin(1));-mag*(x2-origin(2))];
            
            return;
            
        end
        
    end

end

function[y] = fSpin(x1,x2)
global Vbound;
global minDistance;
global origin;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
           if ((x1-origin(1) >= 0) & (x2-origin(2) >=0))
               y(1) = (x2-origin(2));
               y(2) = -(x1-origin(1));
           end

           if ((x1-origin(1) >= 0) & (x2-origin(2) <=0))
               y(1) = (x2-origin(2));
               y(2) = -(x1-origin(1));
           end

           if ((x1-origin(1) <= 0) & (x2-origin(2) <=0))
               y(1) = (x2-origin(2));
               y(2) = -(x1-origin(1));
           end

           if ((x1-origin(1) <= 0) & (x2-origin(2) >=0))
               y(1) = (x2-origin(2));
               y(2) = -(x1-origin(1));
           end
            
            
            
            return;
            
        end
        
    end

end

function[y] = fCustom(x1,x2)
global Vbound;
global minDistance;
global custFunc;

y=[0;0];

for i=1:size(Vbound,1)
    
    if ((abs(Vbound(i,1)-x1) < minDistance(1,1)) && (abs(Vbound(i,2)-x2) < minDistance(1,1)))
        
        
        if (Vbound(i,3) == 2)
            
            y = custFunc(x1,x2);
            return;
            
        end
        
    end

end

