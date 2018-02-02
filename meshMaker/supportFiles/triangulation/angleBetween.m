
%Name: 
%    angleBetween
%
%Purpose:
%    This method will be used to get the clockwise angle between the line
%    segment created by startV and middleV, and the line segment created
%    by endV and middleV
%
%Parameters:
%    startV - (1 x 2) vertex to use for the first line segment
%    middleV - (1 x 2) vertex to use that connects startV and endV
%    endV - (1 x 2) vertex to use for the second line segment
%   
%Return Values:
%    Angle - clockwise angle (in degrees)
%
%Author:
%    Shea Yonker
%
%Date:
%    01/03/2017

function[Angle] = angleBetween(startV,middleV,endV)

v1=startV-middleV;
v2=endV-middleV;

ang = atan2((v1(1)*v2(2)-v2(1)*v1(2)),(v1(1)*v2(1)+v1(2)*v2(2)));
Angle = mod(-180/pi * ang, 360);

end