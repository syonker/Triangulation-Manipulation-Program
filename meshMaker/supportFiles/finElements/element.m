
%Name: 
%    element
%
%Purpose:
%    This method will be used to create each portion of A and F, when
%    elementAssemble is called. This method will deal with each triangle by
%    using the x,y coordinates of its vertices to create the triangle's
%    contribution to the A and F being assembled in elementAssemble.
%
%Parameters:
%    a - (2 x 2) matrix constant
%    b - (2 x 1) vector constant
%    c - real number constant
%    v1 - (2 x 1) vector which reprsesnts the x and y coordinates of v1
%    v2 - (2 x 1) vector which reprsesnts the x and y coordinates of v2
%    v3 - (2 x 1) vector which reprsesnts the x and y coordinates of v3
%    f - function of x and y which will give the amount of force applied
%        at each x,y location
%    n - to access the x or y component of f (1 for x, 2 for y)
%
%Return Values:
%    B - (3 x 3) matrix which represents all the interactions between each 
%        vertex and itself. This will be assembled with other B's
%        representing other triangles and thier respective vertices to
%        create A.
%    q - (3 x 1) vector which represents each vertices funciton value. This will
%        be assembled with other q's representing the oher triangles and
%        their respective vertices to create F.
%
%Author:
%    Shea Yonker
%
%Created:
%    09/18/2017

function [ delA,delF ] = element( a,b,c,v1,v2,v3,f,n )

  %Initialization of return values
  delA = zeros(3);
  delF = zeros(3,1);

  %{ 
    Construction of:
    T - transformation matrix that takes unit triangle to 
        arbitrary triangle in mesh
    Jinv - the inverse of T, which is a tranformation matrix
           that takes an arbitrary triangle in mesh to the
           unit triangle
    DetermT - the jacobian to be used for change of variables
              so the basis functions for the unit triangle can
              be used
  %}
  T = [v3(1)-v1(1) v2(1)-v1(1); v3(2)-v1(2) v2(2)-v1(2)];
  Jinv = inv(T');
  DetermT = abs(T(1,1)*T(2,2)-T(1,2)*T(2,1));

  %Basis functions for the unit triangle
  w1 = @(x,y) 1-x-y;
  w2 = @(x,y) y;
  w3 = @(x,y) x;
  w = {w1 w2 w3}; 

  %Gradient of basis functions
  dw1 = [-1;-1];
  dw2 = [0;1];
  dw3 = [1;0];
  dw = [dw1 dw2 dw3];
  
  %Matrix to implement quadrature rule of order 3 for a 2D right triangle
  z=[0.5 0 1/6;0 0.5 1/6; 0.5 0.5 1/6];
  
  %Construction of B
  for j = 1:3
      
      for k = 1:3
          
          %Implementation of quadrature rule
          for m=1:size(z,1)
              
            delA(j,k)=delA(j,k)+ z(m,3)*((dot(a*(Jinv*dw(:,k)),Jinv*dw(:,j))+...
                   dot(b,Jinv*dw(:,k))*w{j}(z(m,1),z(m,2))+...
                   c*w{k}(z(m,1),z(m,2))*w{j}(z(m,1),z(m,2)))*DetermT);
          
          end
          
      end
      
  end

  %Construction of q
  for j = 1:3
      
      %Implementation of quadrature rule
      for m=1:size(z,1)
        
        r = T(1,:)*[z(m,1);z(m,2)]+v1(1);
        s = T(2,:)*[z(m,1);z(m,2)]+v1(2);     
      
        fvector = f(r,s);
      
        delF(j) = delF(j)+ z(m,3)*(fvector(n)*w{j}(z(m,1),z(m,2)))*DetermT;
        
      end
      
  end

end

