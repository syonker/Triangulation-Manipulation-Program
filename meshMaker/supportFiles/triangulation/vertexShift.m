
%Name: 
%    vertexShift
%
%Purpose:
%    This method will be used to optimize the vertices of any trainglulated 
%    polygon.
%
%Parameters:
%    T - (#triangles x 3) matrix that contians all the vertex numbers for 
%        each triangle
%    V - (#vertices x 2) matrix that contains the x and y coordinates of 
%        each vertex
%    S - (1 x #vertices) matrix that draws the skeleton in a clockwise 
%        fasion 
%  
%Return Values:
%    V - (#vertices x 2) matrix that contains the x and y coordinates of 
%        each vertex with any changes made to it
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [V] = vertexShift(T,V,edgeV,shiftT)

numT = size(T,1);

numV = size(V,1);

%want to find verticies which are a part of at least shiftT different triangles
%so we accumulate the number of triangles each vertex is featured in
%along with the triangle numbers

%this accounts for sharing a max of 20 triangles (arbitrary large number, in
%practice more vertices will always be created so a number like this cant 
%be reached)
%the first value will indicate the number of triangles and each number
%after will give the triangle numbers themselves
Tcount = zeros(numV,21);

for i=1:numT
    
    for j=1:3
    
        %updates the triangle count
        Tcount(T(i,j),1) = Tcount(T(i,j),1) + 1;
        
        %adds the triangle number to the end of the list
        Tcount(T(i,j),Tcount(T(i,j),1)+1) = i;
        
    end
    
end

%allows for 20 triangles (arbitrary)
clockwiseV = zeros(20,2);

for i=1:numV
    
    %need to rule out edge verticies
    edgeVertex = 0;
    for j=1:size(edgeV,1)
        
        if (edgeV(j,:) == V(i,:))
            
            edgeVertex = 1;
            break;
            
        end
        
    end
    
    if (edgeVertex == 1)
        
        continue;
        
    end
    
    %need to rule out the vertex if it lies on the edges
    skip = 0;
    for a=1:size(edgeV,1)
                          
        if (a==size(edgeV,1))
                              
            b=1;
                              
        else
                              
            b=a+1;
                              
        end  
        
        A=edgeV(a,:);
        B=edgeV(b,:);
        
        
        if ( isColinear(A,B,V(i,:))==1 )
            
            skip = 1;
            break;
            
        end    

    end
    
    if (skip == 1)
        
        continue;
        
    end
    
    %then for each vertex where it is in at least shiftT triangles
    if ( Tcount(i,1)>=shiftT )
        
        %we need to make a clockwiseV which gives the verticies around the
        %polygon in clockwise order
        
        n=0;
        
        %for each triangle it is a part of
        for k=1:Tcount(i,1)
            
            %gets the curr triangle number
            currT = Tcount(i,k+1);
            
            %for each vertex in the currT
            for q=1:3
                
               %if the vertex is not the center one
               if ( T(currT,q) ~= i )
                   
                   alreadyAdded = 0;
                   
                   %check if we haven't already added it to our clockwiseV
                   for w=1:n
                       
                       if ( V(T(currT,q),:) == clockwiseV(w,:) )
                           
                           alreadyAdded = 1;
                           
                       end
                       
                   end
                   
                   %add it to the end
                   if (alreadyAdded == 0)
                       
                       n = n+1;
                       
                       clockwiseV(n,:) = V(T(currT,q),:);
                       
                   end
                   
               end
               
            end    
            
                   
        end
        
        
        %at this point clockwiseV is made but it is not clockwise
        clockwiseV = clockwisePoly(clockwiseV,V(i,:),n);
        
        %now that it is clockwise ordered we get our centroid
        cent = centroid(clockwiseV,n);

        
        %Now we check if the shift would increase its overall quality, and if so
        %shift it
       
        %matrix of just the traignles that share this vertex
        smallT = zeros(Tcount(i,1),3);
        
        %for each triangle it is a part of
        for k=1:Tcount(i,1)
            
            %gets the curr triangle number
            currT = Tcount(i,k+1);
            
            %adds it to our smallT
            smallT(k) = T(currT);
            
        end
        
        %we create a Vtest that is exactly V except it has the 
        %elligible shift included
        Vtest = V;
        Vtest(i,:) = cent;
        
        %quality comparison
        if (averageQuality(T,Vtest) >= averageQuality(T,V))  
            
            %implement the change
            V(i,:) = cent;
            
        end 
 
        
    end
    
    
end



end