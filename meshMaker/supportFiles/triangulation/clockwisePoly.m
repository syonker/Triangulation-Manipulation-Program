
%Name: 
%    clockwisePoly
%
%Purpose: 
%    This program organizes a set of vertices in clockwise order 
%
%Parameters:
%    V - (#vertices x 2) vertex matrix giving each vertex's X and Y coordinates
%    middleV - (1 x 2) vertex know to be inside our shape
%    n - number of vertices to reorder
%
%Return Values:
%    clockwiseV - (n x 2) our original vertices, now in clockwise order
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [clockwiseV] = clockwisePoly(V,middleV,n)

    clockwiseV = zeros(n,2);
    
    orderV = zeros(n,3);
    
    compPnt = middleV;
    compPnt(1) = compPnt(1)+1;
    
    for i=1:n
        
        orderV(i,1) = V(i,1);
        orderV(i,2) = V(i,2);
        orderV(i,3) = angleBetween(V(i,:),middleV,compPnt);
        
    end
    
    for i=1:n-1
        
        max = -1;
        
        for j=i:n
            
            if (orderV(j,3) > max)
                
                maxIndex = j;
                max = orderV(j,3);
                
            end
            
        end
        
        temp = orderV(i,:);
        orderV(i,:)=orderV(maxIndex,:);
        orderV(maxIndex,:)=temp;
        
    end
    
    clockwiseV(:,1:2)=orderV(:,1:2);

end