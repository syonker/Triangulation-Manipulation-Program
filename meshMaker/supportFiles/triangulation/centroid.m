
%Name: 
%    centroid
%
%Purpose: 
%    This program calculates the cetroid of a two dimensional object
%
%Parameters:
%    V - (#vertices x 2) vertex matrix giving each vertex's X and Y coordinates in clockwise
%        order
%    numV - the number of vertices to include in our calculation
%
%Return Values:
%    cent - (1 x 2) the X and Y coordinates of the centroid
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [cent] = centroid(V,numV)

cent = [0 0];

sumX = 0;
sumY = 0;

for i=1:(numV-1)
    
    sumX = sumX + ( V(i,1)+V(i+1,1) )*( V(i,1)*V(i+1,2) - V(i+1,1)*V(i,2) );
    sumY = sumY + ( V(i,2)+V(i+1,2) )*( V(i,1)*V(i+1,2) - V(i+1,1)*V(i,2) );
    
end

sumX = sumX + ( V(numV,1)+V(1,1) )*( V(numV,1)*V(1,2) - V(1,1)*V(numV,2) );
sumY = sumY + ( V(numV,2)+V(1,2) )*( V(numV,1)*V(1,2) - V(1,1)*V(numV,2) );

A = signedA(V,numV);

cent(1) = (1/(6*A))*sumX;
cent(2) = (1/(6*A))*sumY;

end