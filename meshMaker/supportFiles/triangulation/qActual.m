
%Name: 
%    qActual
%
%Purpose: 
%    This program gets the actual quality for a given triangle
%
%Parameters:
%    T - (1 x 3) triangle who's quality is to be measured
%    V - (#vertices x 2) vertex matrix giving each vertex's X and Y coordinates
%
%Return Values:
%    q - a value between 0 and 1 representing the quality of the given
%        triangle T
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [quality] = qActual(T,V)

if (size(T,1)>1)

    u = [ V(T(1,2),1)-V(T(1,1),1), V(T(1,2),2)-V(T(1,1),2), 0 ];

    w = [ V(T(1,3),1)-V(T(1,1),1), V(T(1,3),2)-V(T(1,1),2), 0 ];

    v = [ V(T(1,3),1)-V(T(1,2),1), V(T(1,3),2)-V(T(1,2),2), 0 ];

else
    
    u = [ V(T(2),1)-V(T(1),1), V(T(2),2)-V(T(1),2), 0 ];

    w = [ V(T(3),1)-V(T(1),1), V(T(3),2)-V(T(1),2), 0 ];

    v = [ V(T(3),1)-V(T(2),1), V(T(3),2)-V(T(2),2), 0 ];
      
end

area = (.5)*norm(cross(u,w));

sumSidesSqrd = (norm(u)^2)+(norm(w)^2)+(norm(v)^2);

quality = area/sumSidesSqrd;

end