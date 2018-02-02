
%Name: 
%    signedA
%
%Purpose: 
%    This program gets the signed area of a two dimentional polygon given
%    its vertices
%
%Parameters:
%    V - (#vertices x 2) vertex matrix giving each vertex's X and Y coordinates
%    numV - number of vertices to include in the calculation
%
%Return Values:
%    A - the signed area of the shape
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [A] = signedA(V,numV)

sum = 0;

for i=1:(numV-1)
    
    sum = sum + ( V(i,1)*V(i+1,2) - V(i+1,1)*V(i,2) );
    
end

sum = sum + ( V(numV,1)*V(1,2) - V(1,1)*V(numV,2) );

A = .5*sum;

end