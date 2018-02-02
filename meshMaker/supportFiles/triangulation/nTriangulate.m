
%Name: 
%    nTriangulate
%
%Purpose:
%    This method will be used to take a fanned skeleton and add additional
%    triangles until numT >= n
%
%Parameters:
%    T - (#triangles x 3) matrix that contians all the vertex numbers for 
%        each triangle
%    V - (#vertices x 2) matrix that contains the x and y coordinates of 
%        each vertex
%    n - number of triangles we wish to create
%  
%Return Values:
%    T - (#triangles x 3) matrix that contians all the vertex numbers for 
%        each triangle with all additional triangles added
%    V - (#vertices x 2) matrix that contains the x and y coordinates of 
%        each vertex with all additional verticies added
%
%Author:
%    Shea Yonker
%
%Date:
%    09/19/2017

function [T,V] = nTriangulate(T,V,n)

%Current number of triangles we have
numT = size(T,1);

%Our quality array of triangles ordered worst to best
qT = zeros(n+1,4);

%make qT exactly like input T and the rest filled with zeros
for i = 1:numT
    
    qT(i,1:3) = T(i,:);
    
end

%Current number of verticies we have
numV = size(V,1);

%Our new array of verticies
newV = zeros(n+1,2);

%make newV exactly like input V and the rest is filled with zeros
for i=1:numV
    
    newV(i,:) = V(i,:);
    
end

while (numT < n) 
    
    %sort qT so worst quality triangles come first
    %make qT exactly like input T and the rest filled with zeros
    for i = 1:numT
    
        qT(i,4) = q(qT(i,1:3),newV);
    
    end
    qT(1:numT,:) = sortMatrix(qT(1:numT,:),0,4);
   
   %first we add our new vertex which will be the midpoint of the longest
   %side of the triangle with the worst quality
    
   numV = numV + 1;
    
   u = [ newV(qT(1,2),1)-newV(qT(1,1),1), newV(qT(1,2),2)-newV(qT(1,1),2) ];
   w = [ newV(qT(1,3),1)-newV(qT(1,1),1), newV(qT(1,3),2)-newV(qT(1,1),2) ];
   v = [ newV(qT(1,3),1)-newV(qT(1,2),1), newV(qT(1,3),2)-newV(qT(1,2),2) ];
   A=[norm(u),norm(w),norm(v)];
   length = max(A);
   
   if (length==A(1))
       
       %two verticies that make up the longest side
       vOne = qT(1,2);
       vTwo = qT(1,1);
       
       %last vertex that is not part of the longest side
       vThree = qT(1,3);
       
       newV(numV,1) = (newV(qT(1,2),1)+newV(qT(1,1),1))/2;
       newV(numV,2) = (newV(qT(1,2),2)+newV(qT(1,1),2))/2;
       
   elseif (length==A(2))
       
       %two verticies that make up the longest side
       vOne = qT(1,3);
       vTwo = qT(1,1);
       
       %last vertex that is not part of the longest side
       vThree = qT(1,2);
       
       newV(numV,1) = (newV(qT(1,3),1)+newV(qT(1,1),1))/2;
       newV(numV,2) = (newV(qT(1,3),2)+newV(qT(1,1),2))/2;
       
   else
       
       %two verticies that make up the longest side
       vOne = qT(1,2);
       vTwo = qT(1,3);
       
       %last vertex that is not part of the longest side
       vThree = qT(1,1);
       
       newV(numV,1) = (newV(qT(1,3),1)+newV(qT(1,2),1))/2;
       newV(numV,2) = (newV(qT(1,3),2)+newV(qT(1,2),2))/2;
       
   end
   

   %Now we check for adjacent triangles that can be changed
   
   %list for trianlges that we intend to remove from qT (at most 6)
   rmvT = zeros(1,6);
   rmvIndex = 0;
   
   %no matter what will be removing the top triangle with the worst quality
   rmvIndex=rmvIndex+1;
   rmvT(rmvIndex) = 1;
   
   %list for trianlges that we intend to add to qT (at most 8)
   addT = zeros(8,3);
   addIndex = 0;
   
   [indicator, nghbrT, vFour] = nghbrExist(vOne,vThree,qT,numT,1);
   %if there exists another triangle besides top with vOne and vThree
   if (indicator)
   
       %compare its different possible triangle qualities and pick one
       %with the most quality
       if ( ( q(qT(nghbrT,1:3),newV) + q([vOne,vThree,numV],newV) )...
               > ( q([vFour,vOne,numV],newV) + q([vFour,vThree,numV],newV) ) )
           
           %add the chosen ones to array to be added to qT
           addIndex=addIndex+1;
           addT(addIndex,:) = [vOne,vThree,numV];
           
       else
           
           %add the 2 chosen ones to array to be added to qT
           addIndex=addIndex+1;
           addT(addIndex,:) = [vFour,vOne,numV];
           addIndex=addIndex+1;
           addT(addIndex,:) = [vFour,vThree,numV];
           
           %remove the neighboring triangle
           rmvIndex=rmvIndex+1;
           rmvT(rmvIndex) = nghbrT;
           
           
       end
       
       
   %else add trianlge vOne vThree numV to list to be added to qT
   else
       
       %add the 2 chosen ones to array to be added to qT
       addIndex=addIndex+1;
       addT(addIndex,:) = [vThree,vOne,numV];
   
   end
       
   
   [indicator, nghbrT, vFour] = nghbrExist(vTwo,vThree,qT,numT,1);
   %if there exists another triangle besides top with vTwo and vThree
   if (indicator)
   
       %compare its different possible triangle qualities and pick one
       %with the most quality
       if ( ( q(qT(nghbrT,1:3),newV) + q([vTwo,vThree,numV],newV) )...
               > ( q([vFour,vTwo,numV],newV) + q([vFour,vThree,numV],newV) ) )
           
           %add the chosen ones to array to be added to qT
           addIndex=addIndex+1;
           addT(addIndex,:) = [vTwo,vThree,numV];
           
       else
           
           %add the 2 chosen ones to array to be added to qT
           addIndex=addIndex+1;
           addT(addIndex,:) = [vFour,vTwo,numV];
           addIndex=addIndex+1;
           addT(addIndex,:) = [vFour,vThree,numV];
           
           %remove the neighboring triangle
           rmvIndex=rmvIndex+1;
           rmvT(rmvIndex) = nghbrT;
               
       end
           
   %else add trianlge vTwo vThree numV to list to be added to qT
   else
       
       %add the 2 chosen ones to array to be added to qT
       addIndex=addIndex+1;
       addT(addIndex,:) = [vThree,vTwo,numV];

   end 
   
   [indicator, topNghbrT, vThree] = nghbrExist(vTwo,vOne,qT,numT,1);
   %if there exists another triangle besides top with vOne and vTwo
   if (indicator)
       
       %it will be removed because we will bisect it too
       rmvIndex=rmvIndex+1;
       rmvT(rmvIndex)=topNghbrT;
   
         %vThree = that triangles other vertex
         %topNghbrT = that triangles location in qT 
         
               [indicator, nghbrT, vFour] = nghbrExist(vOne,vThree,qT,numT,topNghbrT);
               %if there exists another triangle besides topNghbrT with vOne and vThree
               if (indicator)
                   
                   %compare its different possible triangle qualities and pick one
                   %with the most quality
                   if ( ( q(qT(nghbrT,1:3),newV) + q([vOne,vThree,numV],newV) )...
                           > ( q([vFour,vOne,numV],newV) + q([vFour,vThree,numV],newV) ) )

                       %add the chosen ones to array to be added to qT
                       addIndex=addIndex+1;
                       addT(addIndex,:) = [vOne,vThree,numV];

                   else

                       %add the 2 chosen ones to array to be added to qT
                       addIndex=addIndex+1;
                       addT(addIndex,:) = [vFour,vOne,numV];
                       addIndex=addIndex+1;
                       addT(addIndex,:) = [vFour,vThree,numV];

                       %remove the neighboring triangle
                       rmvIndex=rmvIndex+1;
                       rmvT(rmvIndex) = nghbrT;


                   end


               %else add trianlge vOne vThree numV to list to be added to qT
               else

                   %add the 2 chosen ones to array to be added to qT
                   addIndex=addIndex+1;
                   addT(addIndex,:) = [vThree,vOne,numV];

               end


               [indicator, nghbrT, vFour] = nghbrExist(vTwo,vThree,qT,numT,topNghbrT);
               %if there exists another triangle besides topNghbrT with vTwo and vThree
               if (indicator)

                   %compare its different possible triangle qualities and pick one
                   %with the most quality
                   if ( ( q(qT(nghbrT,1:3),newV) + q([vTwo,vThree,numV],newV) )...
                           > ( q([vFour,vTwo,numV],newV) + q([vFour,vThree,numV],newV) ) )

                       %add the chosen ones to array to be added to qT
                       addIndex=addIndex+1;
                       addT(addIndex,:) = [vTwo,vThree,numV];

                   else

                       %add the 2 chosen ones to array to be added to qT
                       addIndex=addIndex+1;
                       addT(addIndex,:) = [vFour,vTwo,numV];
                       addIndex=addIndex+1;
                       addT(addIndex,:) = [vFour,vThree,numV];

                       %remove the neighboring triangle
                       rmvIndex=rmvIndex+1;
                       rmvT(rmvIndex) = nghbrT;

                   end

               %else add trianlge vTwo vThree numV to list to be added to qT
               else

                   %add the 2 chosen ones to array to be added to qT
                   addIndex=addIndex+1;
                   addT(addIndex,:) = [vThree,vTwo,numV];

               end 
               
               
   end
               
   %We remove all the triangles on the remove list
   tempT=qT(:,1:3);
   
   %first we replace them with all zeros
   for i=1:numT
       
       for j=1:rmvIndex
           
           if (i==rmvT(j))
               
               tempT(i,:)=[0,0,0];
               
           end
           
       end
       
   end
   
   %second we create a new qT without them
   i=1;
   for j=1:numT
       
       if (tempT(j,:)~=[0,0,0])
           
           qT(i,1:3)=tempT(j,:);
           
           i=i+1;
           
       end
       
   end
   
   
   numT = numT-rmvIndex;
   
   for i=numT+1:size(qT,1)
       
       qT(i,1:3)=[0,0,0];
       
   end
   

   
   %We add all the triangles on the add list
   for i=1:addIndex
       
       qT(numT+i,1:3)=addT(i,:);
       
   end
   
   numT = numT+addIndex;
   
  
    
end

%construct our return values
T=zeros(numT,3);

for i=1:numT
    
    T(i,:)=qT(i,1:3);
    
end

V=zeros(numV,2);

for i=1:numV
    
    V(i,:)=newV(i,:);
    
end



end