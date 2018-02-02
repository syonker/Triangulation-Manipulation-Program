
%Name: 
%    elementAssemble
%
%Purpose:
%    This method will be used to effeciently apply the finite element
%    method. By initializing the stiffness martix A to all zeros, we can
%    iterate through each triagnle, adding each of their contributions to
%    the matrix. This allows each triangle to only have to be transformed
%    once.
%
%Parameters:
%    a - (2 x 2) matrix constant
%    b - (2 x 1) vector constant
%    c - real number constant
%    v - (#vertices x 2) matrix which reprsesnts the x and y coordinates of
%        each vertex
%    t - (#triangles x 3) matrix which reprsesnts the three vertices that
%        make up each triangle
%    f - function of x and y which will give the amount of force applied
%        at each x,y location
%    n - to access the x or y component of f (1 for x, 2 for y)
%
%Return Values:
%    A - (#vertices x #vertices) stiffness matrix
%    F - (#vertices x 1) vector which represents each vertices funciton 
%         value
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [A,F] = elementAssemble( a,b,c,v,t,f,n ) 

A = zeros(size(v,1));
F = zeros(size(v,1),1);

for k = 1:size(t,1)
    
    [delA,delF] = element(a,b,c,v(t(k,1),:),v(t(k,2),:),v(t(k,3),:),f,n);
    for i = 1:3
        for j=1:3
            A(t(k,i),t(k,j)) = A(t(k,i),t(k,j)) + delA(i,j);
        end
        F(t(k,i))=F(t(k,i)) + delF(i);
    end
end
end

