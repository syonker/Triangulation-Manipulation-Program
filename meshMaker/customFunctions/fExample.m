
%Name: 
%    fExample
%
%Purpose: 
%    This is an example of how your would make a custom 2D force 
%    function for the program. All custom functions MUST go in this
%    customFunctions folder and take x1,x2 as input while outputing y.
%
%    Feel free to copy this format and delete this function.
%
%Parameters:
%    x1 - the x-value of the vertex which the function is being applied to
%    x2 - the y-value of the vertex which the function is being applied to
%
%Return Values:
%    y - (2 x 1) values of the force function at x1,x2
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function[y] = fExample(x1,x2)

%will apply a force down and to the left towards the third quadrant
y=[-.5;-.5];

end