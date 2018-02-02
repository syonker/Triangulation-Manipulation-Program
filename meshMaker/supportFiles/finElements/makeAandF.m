
%Name: 
%    makeAandF
%
%Purpose:
%    This method will be used to apply the finite element method in two
%    dimensions
%
%Parameters:
%    v - (#vertices x 2) matrix which reprsesnts the x and y coordinates of
%        each vertex
%    t - (#triangles x 3) matrix which reprsesnts the three vertices that
%        make up each triangle
%    f - function of x and y which will give the amount of force applied
%        at each x,y location
%
%Return Values:
%    A - ((2x#vertices) x (2x#vertices)) stiffness matrix
%    F - ((2x#vertices) x 1) vector which represents each vertices funciton 
%         values
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [A,F] = makeAandF(v,t,f)

    % lame constants
    lambda = (21.0)/(2*(1+0.28));
    mu = (21.0*0.28)/((1+0.28)*(1-2*(0.28)));
    
    % initialize A and F to the proper size (n is size of v)
    n = size(v,1);
    A = zeros(2*n);
    F = zeros(2*n,1);
    
    % construction of A11, A12, A21, and A22
    
    %A11
        a=[2*(mu)+lambda, 0; 0, mu];
        [A11 F1] = elementAssemble(a,[0;0],0,v,t,f,1);
    
    %A12
        a=[0, lambda; mu, 0];
        [A12 F1] = elementAssemble(a,[0;0],0,v,t,f,1);
    
    %A21
        a=[0, mu; lambda, 0];
        [A21 F2] = elementAssemble(a,[0;0],0,v,t,f,2);
    
    %A22
        a=[mu, 0; 0, 2*(mu)+lambda];
        [A22 F2] = elementAssemble(a,[0;0],0,v,t,f,2);
    
    % constructing A with A11
        for i = 1:n
            for j = 1:n
                A(i,j) = A11(i,j);
            end
        end
        
    % constructing A with A12
        for i = 1:n
            for j = n+1:2*n
                A(i,j) = A12(i,j-n);
            end
        end
        
    % constructing A with A21
        for i = n+1:2*n
            for j = 1:n
                A(i,j) = A21(i-n,j);
            end
        end
        
    % constructing A with A22
        for i = n+1:2*n
            for j = n+1:2*n
                A(i,j) = A22(i-n,j-n);
            end
        end
        
    % constructs F
        for i = 1:n
            F(i) = F1(i);
        end
        
        for i = n+1:2*n
            F(i) = F2(i-n);
        end
        
end
    
    
    
    
    