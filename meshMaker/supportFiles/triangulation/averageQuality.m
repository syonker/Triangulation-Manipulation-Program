
%Name: 
%    averageQuality
%
%Purpose: 
%    This program draws two dimensional triangle meshes 
%
%Parameters:
%    T - (#triangles x 3) triangle matrix giving each triangle's three vertex numbers
%    V - (#vertices x 2) vertex matrix giving each vertex's X and Y coordinates
%
%Return Values:
%    q - a value between 0 and 1 representing the average quality of all the
%        triangles currently in the mesh (1 being ideal, 0 being garbage).
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [q] = averageQuality(T,V)

q=0;

for i=1:size(T,1)
    
    q=q+qActual(T(i,:),V);
    
end

q = q/size(T,1);

q = q*(12/sqrt(3));

end