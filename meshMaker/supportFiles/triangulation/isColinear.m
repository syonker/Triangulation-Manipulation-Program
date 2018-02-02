
%Name: 
%    isColinear
%
%Purpose: 
%    This program checks if a vertex lies on a straight line joining two
%    other vertices.
%
%Parameters:
%    A - (1 x 2) the first vertex which makes up the line segment in question
%    B - (1 x 2) the second vertex which makes up the line segment in question
%    C - (1 x 2) the vertex which we are checking to see if it lies on the segment
%
%Return Values:
%    answer - a boolean indicating if the vertex lies on the line or not
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function[answer] = isColinear(A,B,C)
        
        answer = 0;
        
        crossProd = (C(2)-A(2))*(B(1)-A(1))-(C(1)-A(1))*(B(2) - A(2));
        
        if (abs(crossProd)>.005)
            
            return;
            
        end
          
        dotProd = dot((B-A),(C-A));
        if ( dotProd < 0 )
            
            return;
            
        end
        
        squaredlengthba = (B(1)-A(1))*(B(1)-A(1))+(B(2)-A(2))*(B(2)-A(2));
        if ( dotProd > squaredlengthba )
            
            return;            
           
        end
            
        answer = 1; 

end