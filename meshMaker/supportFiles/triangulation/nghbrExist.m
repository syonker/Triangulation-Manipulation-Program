
%Name: 
%    nghbrExist
%
%Purpose: 
%    This method will be used to indicate if their is another triangle in
%    qT besides currentT, that has an edge created by v1 and v2. If so, it
%    will also provide information about this triangle.
%
%Parameters:
%    v1 - (1 x 2) the first vertex in currentT's edge
%    v2 - (1 x 2) the second vertex in currentT's edge
%    qT - (#triangles x 3) the entire matrix of all the triangles in the mesh
%    numT - the number of triangles
%    currentT - the current triangle number that is being inspected
%
%Return Values:
%    indicator: boolean showing if a neighbor exists or not
%    nghbrT: the neighbor triangles number in qT if found
%    v3: (1 x 2) vertex that is a part of the other triangle that shares v1
%        and v2
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [indicator, nghbrT, v3] = nghbrExist(v1,v2,qT,numT,currentT)

for i=1:numT
    
    %so we dont check the current triangle
    if (i~=currentT)

        if ((qT(i,1)==v1) && (qT(i,2)==v2) )

            indicator = 1;
            nghbrT = i;
            v3 = qT(i,3);
            return;

        elseif ((qT(i,1)==v1) && (qT(i,3)==v2) )

            indicator = 1;
            nghbrT = i;
            v3 = qT(i,2);
            return;

        elseif ((qT(i,2)==v1) && (qT(i,1)==v2) )

            indicator = 1;
            nghbrT = i;
            v3 = qT(i,3);
            return;

        elseif ((qT(i,2)==v1) && (qT(i,3)==v2) )

            indicator = 1;
            nghbrT = i;
            v3 = qT(i,1);
            return;

        elseif ((qT(i,3)==v1) && (qT(i,1)==v2) )

            indicator = 1;
            nghbrT = i;
            v3 = qT(i,2);
            return;

        elseif ((qT(i,3)==v1) && (qT(i,2)==v2) )

            indicator = 1;
            nghbrT = i;
            v3 = qT(i,1);
            return;

        end
        
    end
    
end

%made it through therefore does not exist
indicator=0;
nghbrT=0;
v3=0;

end