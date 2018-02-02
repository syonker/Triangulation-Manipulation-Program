
%Name: 
%    triangulateGUI
%
%Purpose:
%    This is the main gui which opens initially when you run the program.
%    It allows the user to create their closed polygon shape, and mesh it
%    to their desire. From then they can open the finiteElements gui through
%    the corresponding button.
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function varargout = triangulateGUI(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @triangulateGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @triangulateGUI_OutputFcn, ...
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



% --- Executes just before triangulateGUI is made visible.
function triangulateGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to triangulateGUI (see VARARGIN)
global xMin;
global xMax;
global yMin;
global yMax;
global axisOn;
global loadingOn;
global loadingOff;
global saving;
global noPlot;

path(path,'supportFiles\triangulation');
path(path,'supportFiles\plotting');
path(path,'supportFiles\plotting\export_fig');
path(path,'supportFiles\finElements');
path(path,'supportFiles/triangulation');
path(path,'supportFiles/plotting');
path(path,'supportFiles/plotting/export_fig');
path(path,'supportFiles/finElements');

loadingOn = sprintf('L\nO\nA\nD\n I\nN\nG\n *\n\n *\n\n *\n *\n *\n\n *\n\n *\nL\nO\nA\nD\n I\nN\nG');
loadingOff = ' ';
saving = sprintf('\nS\nA\nV\n I\nN\nG\n *\n\n *\n\n *\n *\n *\n\n *\n\n *\nS\nA\nV\n I\nN\nG\n');

set(handles.text20,'String',loadingOff);

noPlot = 1;

axisOn = 1;

xMin = -10;
xMax = 10;
yMin = -10;
yMax = 10;

%Set default instructions
set(handles.text16, 'String', 'Welcome! Choose which plot to start or feel free to change the axis properties.');


% Choose default command line output for triangulateGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = triangulateGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%ZOOM IN BUTTON
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
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


%ZOOM OUT BUTTON
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
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


%XMIN VALUE
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


%YMIN VALUE
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


%PLOT Function
function plot(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pointNumber;
global originalV;
global V;
global T;
global numV;
global xMin;
global xMax;
global yMin;
global yMax;
global clockwise;
global plotRunning
global numT;
global noPlot;


if (plotRunning == 1)
    
    cla;
    
end

plotRunning = 1;

%set the desired number of triangles to 0
set(handles.edit3, 'String',  num2str(0)); 

V = zeros(1000,2);
numV = 0;

T = zeros(1,3);

pointNumber = 1;

%clear the figure
cla;

%update average triangle quality
set(handles.text15, 'String', 'N/A');
%update number of triangles displayed
set(handles.text7, 'String', '0');
%update number of verticies displayed
set(handles.text9, 'String', '0');

intersection = 0;

brokeEarly = 0;

while (1==1)

if (((numV+1) > 1) && (intersection == 0))
    
    if (brokeEarly == 1)
        
        brokeEarly = 0;
        
    else
            
        prevx = x;
        prevy = y;
    
    end
    
end

[x,y] = ginput(1);


%check to see if enter was clicked
if (x)
    
    
else
    
    if ((numV) >= 3)
        
        
        intersection = 0;

        %check if last point violates the shape by crossing
        %any of the lines previously formed                      
        for a=1:numV-1

            if (a==numV)

                b=1;

            else

                b=a+1;

            end   
            
            x=V(1,1);
            y=V(1,2);

            A=[V(a,1)-x,V(b,1)-x;V(a,2)-y,V(b,2)-y];
            B=[V(a,1)-prevx,V(b,1)-prevx;V(a,2)-prevy,V(b,2)-prevy];
            C=[x-V(a,1),prevx-V(a,1);y-V(a,2),prevy-V(a,2)];
            D=[x-V(b,1),prevx-V(b,1);y-V(b,2),prevy-V(b,2)];

            dA = det(A);
            dB = det(B);
            dC = det(C);
            dD = det(D);

            if (((sign(dA) == 1) && (sign(dB) == -1)) || ...
                      ((sign(dA) == -1) && (sign(dB) == 1)))

              if (((sign(dC) == 1) && (sign(dD) == -1)) || ...
                          ((sign(dC) == -1) && (sign(dD) == 1)))

                  %Shows intersection was found & stops further testing
                  intersection = 1;
                  %want to exit while loop and move on to next
                  %value of j
                  break;

              end

            end

        end

        %if this is true then we want the user to reselect a new vertex
        if (intersection == 1)

          uiwait(msgbox({'Keep selecting points!' 'You must create your polygon without crossing over previous edges.'}, 'Crossed Previous Edge','error','modal'));  

          brokeEarly = 1;
          
          intersection = 0;
          
          continue;

        else
          
            break;
            
        end

        
    else
        
        if (numV > 0)
        
            brokeEarly = 1;
            
        end
        
        uiwait(msgbox({'Not enough verticies!' 'There must be at least three veticies to make a polygon.'}, 'Click More Points!','error','modal'));
        
        continue;
    
    end
    
    
end


intersection = 0;

%check if new point violates the shape by crossing
%any of the lines previously formed                      
for a=1:numV-1
                          
    if (a==numV)
                              
        b=1;
                              
    else
                              
        b=a+1;
                              
    end                   

    A=[V(a,1)-x,V(b,1)-x;V(a,2)-y,V(b,2)-y];
    B=[V(a,1)-prevx,V(b,1)-prevx;V(a,2)-prevy,V(b,2)-prevy];
    C=[x-V(a,1),prevx-V(a,1);y-V(a,2),prevy-V(a,2)];
    D=[x-V(b,1),prevx-V(b,1);y-V(b,2),prevy-V(b,2)];

    dA = det(A);
    dB = det(B);
    dC = det(C);
    dD = det(D);

    if (((sign(dA) == 1) && (sign(dB) == -1)) || ...
              ((sign(dA) == -1) && (sign(dB) == 1)))

      if (((sign(dC) == 1) && (sign(dD) == -1)) || ...
                  ((sign(dC) == -1) && (sign(dD) == 1)))

          %Shows intersection was found & stops further testing
          intersection = 1;
          %want to exit while loop and move on to next
          %value of j
          break;

      end

    end

end

%if this is true then we want the user to reselect a new vertex
if (intersection == 1)
    
  uiwait(msgbox({'Invalid New Vertex!' 'You must create your polygon without crossing over previous edges.'}, 'Crossed Previous Edge','error','modal'));  

  continue;

end

%check to see if the point was clicked outside of the bounds
if ((x > xMax) || (x < xMin) || (y > yMax) || (y < yMin) )
    
    uiwait(msgbox({'Clicked Out of Bounds!' 'You must choose verticies within your x and y max and mins.'}, 'Out of Bounds','error','modal'));
    
    intersection = 1;
    continue;
    
end


scatter(x,y);

%add it to our vector of verticies
numV = numV + 1;

V(numV,1) = x;
V(numV,2) = y;

%update our visual vertex counter
set(handles.text9, 'String', num2str(numV));

if (pointNumber == 1)
    
    firstx = x;
    firsty = y;
    
else 
    
    line([prevx,x],[prevy,y],'Color','black');
    
end

if (pointNumber >3)
    
    delete(lastLine);
    
end

if (pointNumber >= 3)
    
    lastLine = line([firstx,x],[firsty,y],'Color','black','LineStyle','--');
    
end


pointNumber = pointNumber + 1;


end

tempV = zeros(numV,2);

%if the verticies were given in a clockwise fashion
if (clockwise == 1)

    for i=1:numV
    
        tempV(i,1)=V(i,1);
        tempV(i,2)=V(i,2);
    
    end

%if the verticies were given in a counter-clockwise fashion
else
    
    for i=1:numV
    
        tempV(i,1)=V(numV-i+1,1);
        tempV(i,2)=V(numV-i+1,2);
    
    end
    
end

V = tempV;

originalV = V;

lastLine.LineStyle = '-';

if (numV == 3)
    
    numT = 1;
    T = [1 2 3];
    set(handles.edit3, 'String', num2str(1));

    %update average triangle quality
    set(handles.text15, 'String', num2str(averageQuality(T,V)));
    %update number of triangles displayed
    set(handles.text7, 'String', num2str(1));
    
else
    
    numT = 0;
    
end

%Set instructions
set(handles.text16, 'String', 'Change the number of triangles field to that of your choosing and hit triangulate.');

noPlot = 0;

plotRunning = 0;


%TRIANGULATE BUTTON
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originalV;
global V;
global T;
global numV;
global numT;
global loadingOn;
global loadingOff;
global noPlot;

if (noPlot)
    
    uiwait(msgbox({'You must first plot your shape before you can triangulate it.'}, 'No Plot Yet','error','modal'));
    
    return;
    
end


set(handles.text20, 'String', loadingOn);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

tempT = numT;
numT = str2num(get(handles.edit3, 'String'));

if (numT == 0)
    
    %need to plot just original shape
    cla;
    numV = size(originalV,1);
    for i=2:numV
       
        line([originalV(i,1),originalV(i-1,1)],[originalV(i,2),originalV(i-1,2)],'Color','black');
        
    end
    line([originalV(1,1),originalV(numV,1)],[originalV(1,2),originalV(numV,2)],'Color','black');
    
    if (numV ~= 3)
    
    T = zeros(1,3);
    %update average triangle quality
    set(handles.text15, 'String', 'N/A');
    %update number of triangles displayed
    set(handles.text7, 'String', num2str(0));
    %update our visual vertex counter
    set(handles.text9, 'String', num2str(numV));
    
    else
        
        numT = 1;
        T = [1 2 3];
        set(handles.edit3, 'String', num2str(1));

        %update average triangle quality
        set(handles.text15, 'String', num2str(averageQuality(T,V)));
        %update number of triangles displayed
        set(handles.text7, 'String', num2str(1));
        
    end
    
    set(handles.text20, 'String', loadingOff);

    %Reset instructions
    set(handles.text16, 'String', prevInstructions);
    
    return;
    
end

if (numT < 0)
    
    %set the current number of triangles 
    set(handles.edit3, 'String', get(handles.text7, 'String')); 
    uiwait(msgbox({'Invalid Value!' 'Number of triangles cannot be negative'}, 'Negative Triangles','error','modal'));
    set(handles.text20, 'String', loadingOff);
    %Reset instructions
    set(handles.text16, 'String', prevInstructions);
    numT = tempT;
    return
    
end

%clear the figure
cla;

needToFan = 0;

%if we need to fan the skeleton
if ((T(1,1)==0) || (size(T,1) >= numT) )
    
    V=originalV;
    
    numV = size(V,1);

    S=zeros(numV);

    for i=1:numV
    
        S(i)=i;
    
    end

    T = triangulate(S,V);
    needToFan = 1;

end

if ((size(T,1) >= numT) && (needToFan == 1))
    
    plot2d(T,V);
    
else
    
    [T,V] = nTriangulate(T,V,numT);
    
    plot2d(T,V);
    
end

set(handles.edit3, 'String', num2str(size(T,1)));

%update average triangle quality
set(handles.text15, 'String', num2str(averageQuality(T,V)));
%update number of triangles displayed
set(handles.text7, 'String', num2str(size(T,1)));
%update our visual vertex counter
set(handles.text9, 'String', num2str(size(V,1)));

set(handles.text20, 'String', loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);


%TRIANGULATE W/ AUTO SHIFT
% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originalV;
global V;
global T;
global numV;
global numT;
global loadingOn;
global loadingOff;
global noPlot;

if (noPlot)
    
    uiwait(msgbox({'You must first plot your shape before you can triangulate it.'}, 'No Plot Yet','error','modal'));
    
    return;
    
end

set(handles.text20, 'String', loadingOn);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

tempT = numT;
numT = str2num(get(handles.edit3, 'String'));

if (numT == 0)
    
    %need to plot just original shape
    cla;
    numV = size(originalV,1);
    for i=2:numV
       
        line([originalV(i,1),originalV(i-1,1)],[originalV(i,2),originalV(i-1,2)],'Color','black');
        
    end
    line([originalV(1,1),originalV(numV,1)],[originalV(1,2),originalV(numV,2)],'Color','black');
    
    if (numV ~= 3)
    
    T = zeros(1,3);
    %update average triangle quality
    set(handles.text15, 'String', 'N/A');
    %update number of triangles displayed
    set(handles.text7, 'String', num2str(0));
    %update our visual vertex counter
    set(handles.text9, 'String', num2str(numV));   
    
    else
        
        numT = 1;
        T = [1 2 3];
        set(handles.edit3, 'String', num2str(1));

        %update average triangle quality
        set(handles.text15, 'String', num2str(averageQuality(T,V)));
        %update number of triangles displayed
        set(handles.text7, 'String', num2str(1));
        
    end
    
    set(handles.text20, 'String', loadingOff);
    
    %Reset instructions
    set(handles.text16, 'String', prevInstructions);
    
    return;
    
end

if (numT < 0)
    
    %set the current number of triangles 
    set(handles.edit3, 'String', get(handles.text7, 'String')); 
    uiwait(msgbox({'Invalid Value!' 'Number of triangles cannot be negative'}, 'Negative Triangles','error','modal'));
    set(handles.text20, 'String', loadingOff);
    %Reset instructions
    set(handles.text16, 'String', prevInstructions);
    numT = tempT;
    return
    
end

%clear the figure
cla;

needToFan = 0;

%if we need to fan the skeleton
if ((T(1,1)==0) || (size(T,1) >= numT) )
    
    V=originalV;
    
    numV = size(V,1);

    S=zeros(numV);

    for i=1:numV
    
        S(i)=i;
    
    end

    T = triangulate(S,V);
    needToFan = 1;

end

if ((size(T,1) >= numT) && (needToFan == 1))
    
    plot2d(T,V);
    
else
    
    oldCount = size(T,1);
    
    if (numT - size(T,1) >= 75)
    
        for p=1:4

            targetT = oldCount + ceil(p*((numT-oldCount)/4));

            [T,V] = nTriangulate(T,V,targetT);

            V = vertexShift(T,V,originalV,1);

        end
    
    elseif (numT - size(T,1) >= 30)
        
        for p=1:2

            targetT = oldCount + ceil(p*((numT-oldCount)/2));

            [T,V] = nTriangulate(T,V,targetT);

            V = vertexShift(T,V,originalV,1);

        end
    
    elseif (numT - size(T,1) >= 10)
        
        for p=1:3

            targetT = oldCount + ceil(p*((numT-oldCount)/3));

            [T,V] = nTriangulate(T,V,targetT);

            V = vertexShift(T,V,originalV,1);

        end
        
    else
        
        [T,V] = nTriangulate(T,V,numT);

        V = vertexShift(T,V,originalV,1);
        
    end
     
    plot2d(T,V);
    
end

set(handles.edit3, 'String', num2str(size(T,1)));

%update average triangle quality
set(handles.text15, 'String', num2str(averageQuality(T,V)));
%update number of triangles displayed
set(handles.text7, 'String', num2str(size(T,1)));
%update our visual vertex counter
set(handles.text9, 'String', num2str(size(V,1)));

set(handles.text20, 'String', loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);

%NUMBER OF TRIANGLES VALUE
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%SET AXIS MANUALLY BUTTON
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
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


% --- Executes during object creation, after setting all properties.
function plot1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global firstTimePloting;
global xMin;
global xMax;
global yMin;
global yMax;

firstTimePloting = 1;

xMin = -10;
xMax = 10;
yMin = -10;
yMax = 10;

axis([xMin,xMax,yMin,yMax]);
hold on;

ax = gca;
ax.XColor = 'blue';
ax.YColor = 'blue';
ax.XLim = [-10 10];
ax.YLim = [-10 10];


%FINISH PLOT Clockwise BUTTON
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global clockwise;

clockwise = 1;

%Set instructions
set(handles.text16, 'String', sprintf('Simply click your verticies on the graph below in a clockwise fashion.\n                Hit the enter key when you are finished.'));

%calls plot function
plot(hObject, eventdata, handles);



%NUMBER OF VERTICIES VALUE
% --- Executes during object creation, after setting all properties.
function text9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%NUMBER OF TRIANGLES VALUE
% --- Executes during object creation, after setting all properties.
function text7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%XMAX VALUE
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


%YMAX VALUE
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pushbutton5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%AVERAGE TRIANGLE QUALITY VALUE
%STARTS AT N/A, THEN SHOULD BE A VALUE BETWEEN 0 AND 1
% --- Executes during object creation, after setting all properties.
function text15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%FINISH PLOT CounterCLOCKWISE BUTTON
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global clockwise;

clockwise = 0;

%Set instructions
set(handles.text16, 'String', sprintf('Simply click your verticies on the graph below in a counterclockwise fashion.\n                Hit the enter key when you are finished.'));


%calls plot function
plot(hObject, eventdata, handles);


%CLICK NEW ORIGIN BUTTON
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
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

set(handles.text20, 'String', loadingOn);
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
   
set(handles.text20, 'String', loadingOff);


%INSTRUCTIONS TEXT
% --- Executes during object creation, after setting all properties.
function text16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%VERTEX SHIFT BUTTON
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global V;
global T;
global originalV;
global loadingOn;
global loadingOff;
global noPlot;


shiftT = str2num(get(handles.edit6, 'String'));

if (shiftT < 3)
    
    uiwait(msgbox({'Invalid Value!' 'Cannot have an interior vertex connected to less than three triangles.'}, 'Less Than Three Triangles','error','modal'));
    return;
    
end

if ((T(1,1) == 0) || (noPlot))
    
    uiwait(msgbox({'No plot yet!' 'Before you shift any verticies you need to add a plot and some triangles.'}, 'Need Mesh','error','modal'));
    return;
    
end

set(handles.text20, 'String', loadingOn);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

V = vertexShift(T,V,originalV,shiftT);

%clear the figuree
cla;

plot2d(T,V);


%update average triangle quality
set(handles.text15, 'String', num2str(averageQuality(T,V)));

set(handles.text20, 'String', loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%shiftT FOR VERTEX SHIFT
% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when uipanel1 is resized.
function uipanel1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%AXIS ON/OFF
% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
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



%APPLY FORCES BUTTON (CALLS FINELEMENTS GUI)
% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global numT;
global noPlot;

if (noPlot)
    
    uiwait(msgbox({'You must first plot your shape before you can apply forces to it.'}, 'No Plot Yet','error','modal'));
    
    return;
    
end

if (numT == 0)
    uiwait(msgbox({'No triangles yet!' 'Before you apply forces you need to add some triangles.'}, 'Need Triangles','error','modal'));
    return;
end

finElements;
close(triangulateGUI);


%LOADING TEXT
% --- Executes during object creation, after setting all properties.
function text20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%SAVE IMAGE
% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global loadingOff;
global saving;

set(handles.text20,'String',saving);

%save current instructions
prevInstructions = get(handles.text16, 'String');

%Set instructions
set(handles.text16, 'String', '< - - - - - - - - - - - - - - - - - - - - - - - -  Please Wait  - - - - - - - - - - - - - - - - - - - - - - - - >');

drawnow;

filename = get(handles.edit8, 'String');

if (isempty(filename))
    
    filename = 'untitled';
    
end

ax = gca;

oldPath = pwd;
cd saveFiles;
fpath = pwd;
cd ..;

fullName = fullfile(fpath,filename);
export_fig(ax,fullName,'-jpg');

set(handles.text20,'String',loadingOff);

%Reset instructions
set(handles.text16, 'String', prevInstructions);



%NAME
function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
