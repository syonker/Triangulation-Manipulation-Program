
%Name: 
%    sortedA
%
%Purpose: 
%    This program will create a sorted version of the matrix A either by the
%    first column or by the first row 
%
%Parameters:
%    A - the matrix to sort
%    byRow - boolean indicating if we should sort by row
%    byCol - boolean indicating if we should sort by column
%
%Return Values:
%    sortedA - the now sorted matrix
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function[sortedA] = sortMatrix(A,byRow,byCol)

    if (byCol ~= 0)

        [~,I]=sort(A(:,byCol));
    
        sortedA=A(I,:);
        
    else
        
        [~,I]=sort(A(byRow,:));
    
        sortedA=A(:,I);
        
    end

end