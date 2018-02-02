
%Name: 
%    triangulate
%
%Purpose:
%    This method will be used to connect the vertices of any
%    polygon skeleton to fill the shape using traingles.
%
%Parameters:
%    S - (1 x #vertices) matrix that draws the skeleton in a clockwise 
%        fasion 
%    V - (#vertices x 2) matrix that contains the x and y coordinates of 
%        each vertex
%   
%Return Value:
%    T - (#triangles x 3) matrix that contains the vertices that make up 
%        each triangle 
%
%Author:
%    Shea Yonker
%
%Created:
%    09/18/2017

function [ T ] = triangulate( S,V )

%Initialization of variables 
  
  %Number of vertices
  numV = size(S,2);
  
  %Matrix for storage of the new lines created (intentionally too large)
  nLine = zeros(1,4*numV);
  
  %Matrix for storage of Triangles
  T = zeros(10*numV,3);
    
  %Keeps track of how many triangles have been added to our T matrix
  nT = 0; 
  
  %if we are given a shape with less than three verticies return empty
  %matrix
  if (numV < 3)
      
      T = [];
      
      return;
      
  end
  
  %if we are given a shape with only three verticies nothing needs to be
  %done
  if (numV == 3)
      
      T = [1 2 3];
      
      return;
      
  end
  
  %if we are given a shape with only 4 verticies a split down the middle
  %will suffice
  if (numV == 4)
      
      T = [1 2 4;2 3 4];
      
      return;
      
  end
  
  %for each vertex
  for i=1:numV
      
      %gets the surrounding verticies
      if (i==1)
          
          iminus1 = numV;
          iplus1 = 2;
          
      elseif (i==numV)
          
          iminus1 = numV-1;
          iplus1 = 1;
          
      else 
          
          iminus1 = i-1;
          iplus1 = i+1;
          
      end
      
      %for each vertex not equal to the current one or the surrounding
      %verticies
      for j=1:numV
          
          if ( (j==i) || (j==iminus1) || (j==iplus1) )
              
              continue;
              
          else
              
              %check to see if the clockwise angle between line i,iplus1 
              %and line i,j is less than that between line i,iplus1 and 
              %line i,iminus1
              if ( angleBetween(V(iplus1,:),V(i,:),V(j,:)) > ...
                            angleBetween(V(iplus1,:),V(i,:),V(iminus1,:)) )
                  
                  continue
                  
              else
                  
              %if we arrive here then the angle has been satisfied
                             
                  %Check if creating a line b/w i & j would cross any of 
                  %the new lines that have been created while running this
                  %program

                  %will show if we find an intersection
                  intersection = 0;
                  
                  %Gets the number of new lines
                  for z = 1:(4*numV)

                      if (nLine(1,z) == 0)

                          break;

                      end  

                  end

                  a = 1;
                  while a < z-1 

                      b = a+1;

                      q = nLine(1,a);

                      r = nLine(1,b);
                      
                      %if this is a duplicate of a new line
                      if ((q==i) && (r==j) || (q==j) && (r==i))
                          
                          intersection = 1;
                          
                          break;
                          
                      end        

                      A=[V(q,1)-V(i,1),V(r,1)-V(i,1);V(q,2)-V(i,2),V(r,2)-V(i,2)];
                      B=[V(q,1)-V(j,1),V(r,1)-V(j,1);V(q,2)-V(j,2),V(r,2)-V(j,2)];
                      C=[V(i,1)-V(q,1),V(j,1)-V(q,1);V(i,2)-V(q,2),V(j,2)-V(q,2)];
                      D=[V(i,1)-V(r,1),V(j,1)-V(r,1);V(i,2)-V(r,2),V(j,2)-V(r,2)];

                      dA = det(A);
                      dB = det(B);
                      dC = det(C);
                      dD = det(D);

                      if (((sign(dA) == 1) && (sign(dB) == -1)) || ...
                              ((sign(dA) == -1) && (sign(dB) == 1)))

                          if (((sign(dC) == 1) && (sign(dD) == -1)) || ...
                                  ((sign(dC) == -1) && (sign(dD) == 1)))

                              %Shows intersection was found & stops further
                              %testing
                              intersection = 1;
                              break;

                          end

                      end

                      a = a+2;

                  end

                  if (intersection == 1)

                      continue;
                      
                      
                  %everything checks out so far if we arrive here   
                  else
                      
                      %check to see if creating this new line b/w i and j 
                      %would cross any of the sides that make up the shape 
                      %of the skeleton
                      
                      for a=1:numV
                          
                          if (a==numV)
                              
                              b=1;
                              
                          else
                              
                              b=a+1;
                              
                          end

                          A=[V(a,1)-V(i,1),V(b,1)-V(i,1);V(a,2)-V(i,2),V(b,2)-V(i,2)];
                          B=[V(a,1)-V(j,1),V(b,1)-V(j,1);V(a,2)-V(j,2),V(b,2)-V(j,2)];
                          C=[V(i,1)-V(a,1),V(j,1)-V(a,1);V(i,2)-V(a,2),V(j,2)-V(a,2)];
                          D=[V(i,1)-V(b,1),V(j,1)-V(b,1);V(i,2)-V(b,2),V(j,2)-V(b,2)];

                          dA = det(A);
                          dB = det(B);
                          dC = det(C);
                          dD = det(D);

                          if (((sign(dA) == 1) && (sign(dB) == -1)) || ...
                                      ((sign(dA) == -1) && (sign(dB) == 1)))

                              if (((sign(dC) == 1) && (sign(dD) == -1)) || ...
                                          ((sign(dC) == -1) && (sign(dD) == 1)))

                                  %Shows intersection was found & stops further testing
                                  intersection = 1;
                                  %want to exit while loop and move on to next
                                  %value of j
                                  break;

                              end

                          end

                      end

                      if (intersection == 1)

                          continue;

                      %if we get here we know we have a legitimate diagonal
                      else

                           %creates diagonal (new line)

                           %Gets the number of new lines
                           for z = 1:(4*(numV))

                               if (nLine(1,z) == 0)

                                   break;

                               end

                           end

                           %saves the new line
                           nLine(1,z) = i;
                           nLine(1,z+1) = j;


                      end 
                      
                  end
                  
              end
              
          end
          
      end
      
  end
  %finished running through all the verticies      

  %so now we create triangle matrix for return
  
  %same as S just one element longer with the repeated 1st element
  %makes for easier implementation
  Smod = zeros(1,numV+1);
  
  for index=1:numV
      
      Smod(index)=S(index);
      
  end
  
  Smod(numV+1) = S(1);
  
  %first we go through each vertex and check for triangles made by two
  %sides and one new line
  
  %can do this by steping through new lines and checking if any of the
  %pairs (A,B) are only two away from one another on the skeleton
  for nlIndex=1:2:z
      
      A = nLine(nlIndex);
      B = nLine(nlIndex+1);
      
      if ((A==0) || (B==0))
          
          break;
          
      end
      
      if (S(A) == (S(B)-2))
          
          %finds the middle vertex as i
          for i=1:numV
              if (S(i) == S(B)-1)
                  break;
              end 
          end
          
          %create new triangle A,B,i
          nT = nT+1;
                  
          T(nT,1) = A;
          T(nT,2) = B;
          T(nT,3) = i;
          
      elseif ((S(A)==2) && (S(B)==numV))
          
          %finds the middle vertex as i
          for i=1:numV
              if (S(i) == 1)
                  break;
              end 
          end
          
          %create new triangle A,B,i
          nT = nT+1;
                  
          T(nT,1) = A;
          T(nT,2) = B;
          T(nT,3) = i;
          
          
      elseif ((S(A)==1) && (S(B)==numV-1))
          
          %finds the middle vertex as i
          for i=1:numV
              if (S(i) == numV)
                  break;
              end 
          end
          
          %create new triangle A,B,i
          nT = nT+1;
                  
          T(nT,1) = A;
          T(nT,2) = B;
          T(nT,3) = i;
           
      end 
      
  end
  
  
  %second we go through each edge (p,q) and look for any (p,x) (q,x) pairings
  %in the new lines which will account for all triangles made by 1 side
  %and two new lines
  for sIndex=1:numV
      
      %gets the edge (p,q)
      p = Smod(sIndex);
      q = Smod(sIndex+1);
      
      for nlIndex=1:2:z
          
          %gets each newline (A,B)
          A = nLine(nlIndex);
          B = nLine(nlIndex+1);
          
          if ((A==0) || (B==0))
          
              break;
          
          end
          
          x=0;
          y=0;
          
          if (A==p)
              
              x=B;
              
          elseif (B==p)
              
              x=A;
              
          elseif (A==q)
              
              y=B;
              
          elseif (B==q)
              
              y=A;
              
          else
              
              continue;
              
          end
          
        if (x~=0)
          
          %runs through the other newlines
          for nlIndex2=1:2:z
              
              if (nlIndex2==nlIndex)
                  
                  continue;
                  
              end
          
              %gets each newline (AA,BB)
              AA = nLine(nlIndex2);
              BB = nLine(nlIndex2+1);
              
              if ((AA==0) || (BB==0))
          
                  break;
          
              end
              
              if ( ((AA==x) && (BB==q)) || ((BB==x) && (AA==q)) )
                  
                  
                  %create new triangle p,q,x
                  nT = nT+1;
                  
                  T(nT,1) = p;
                  T(nT,2) = q;
                  T(nT,3) = x;
                  
                  
                  break;
                  
              end
              
          end
          
        elseif (y~=0)
            
            %runs through the other newlines
          for nlIndex2=1:2:z
              
              if (nlIndex2==nlIndex)
                  
                  continue;
                  
              end
          
              %gets each newline (AA,BB)
              AA = nLine(nlIndex2);
              BB = nLine(nlIndex2+1);
              
              if ((AA==0) || (BB==0))
          
                  break;
          
              end
              
              if ( ((AA==y) && (BB==p)) || ((BB==y) && (AA==p)) )
                  
                  
                  %create new triangle p,q,y
                  nT = nT+1;
                  
                  T(nT,1) = p;
                  T(nT,2) = q;
                  T(nT,3) = y;
                  
                  
                  break;
                  
              end
              
          end
            
            
        end

      end
         
  end
          
  %look for trianlges created by all new lines
  for Aindex=1:2:z
      
      if(nLine(Aindex)==0) 
          
          break;
          
      end
      
      A=nLine(Aindex);
      B=nLine(Aindex+1);
      
      for AAindex=Aindex+2:2:z
          
          if(nLine(AAindex)==0)
              
              break;
              
          end
          
          if(nLine(AAindex)==A)
              
              BB=nLine(AAindex+1);
              
          else
              
              break;
              
          end
          
          for AAAindex=AAindex+2:2:z
              
              if(nLine(AAAindex)==0)
                  
                  break;
                  
              end
              
              AAA=nLine(AAAindex);
              BBB=nLine(AAAindex+1);
              
              if((AAA==B) && (BBB==BB))
                  
                  %save triangle
                  nT=nT+1;
                  
                  T(nT,1)=A;
                  T(nT,2)=B;
                  T(nT,3)=BB;
                  
              end
              
          end
          
      end
      
  end
  
  %for each triangle except the last
  for index=1:nT-1
      
      a = T(index,1);
      b = T(index,2);
      c = T(index,3);
      
      %for all triangles to come
      for index2=index+1:nT
          
          %if any of the triangles vertecies are equal to a
          if ( (T(index2,1)==a) || (T(index2,2)==a) || (T(index2,3)==a) )
              
              %if any of the triangles vertecies are equal to b
              if ( (T(index2,1)==b) || (T(index2,2)==b) || (T(index2,3)==b) )
                  
                  %if any of the triangles vertecies are equal to c
                  if ( (T(index2,1)==c) || (T(index2,2)==c) || (T(index2,3)==c) )
                      
                      %Replace the triangles entries with all zeros to mark
                      %it for removal because it is a duplicate
                      T(index2,1) = 0;
                      T(index2,2) = 0;
                      T(index2,3) = 0;
                      
                  end
                  
              end
                  
          end
          
      end         
      
  end
  
  %for storage of unique triangles
  uniqueT = zeros(numV-2,3);
  numUnique = 0;
  
  for index=1:nT
      
      %indicates it is a unique triangle
      if (T(index,1) ~= 0)
          
          numUnique = numUnique+1;
          uniqueT(numUnique,1) = T(index,1);
          uniqueT(numUnique,2) = T(index,2);
          uniqueT(numUnique,3) = T(index,3);
          
      end
      
  end
  
  %get rid of extra zeros at the end
  
  finalTriangleNumber=0;
  
  for index=1:(numV-2)
      
      if (uniqueT(index,1)==0)
          
          break;
          
      else
          
          finalTriangleNumber=finalTriangleNumber+1;
          
      end
      
  end
  
  finalTriangleVector=zeros(finalTriangleNumber,3);
  
  for index=1:finalTriangleNumber
      
      finalTriangleVector(index,1) = uniqueT(index,1);
      finalTriangleVector(index,2) = uniqueT(index,2);
      finalTriangleVector(index,3) = uniqueT(index,3);
      
  end
  
  %change name to satify T return value
  T = finalTriangleVector;
                      
      
end
      