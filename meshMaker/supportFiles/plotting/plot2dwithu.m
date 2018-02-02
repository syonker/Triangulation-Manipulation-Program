
%Name: 
%    plot2dwithu
%
%Purpose: 
%    This program draws two dimensional triangle meshes with the shape's 
%    added displacement after using the finite element method.
%
%Parameters:
%    t - (#triangles x 3) triangle matrix giving each triangle's three vertex numbers
%    v - (#vertices x 2) vertex matrix giving each vertex's X and Y coordinates
%    u - (#vertices x 2) the displacement each vertex recieves
%
%Return Values:
%    plotH - a plot handle
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [plotH] = plot2dwithu(t,v,u)
  hold on;
  n=size(t,1);
  b=size(v,1);
  plotH = zeros(size(t,1),3);
  for i=1:n
    plotH(i,1) = plot([v(t(i,1),1)+u(t(i,1)) v(t(i,2),1)+u(t(i,2))], ...
        [v(t(i,1),2)+u(t(i,1)+b) v(t(i,2),2)+u(t(i,2)+b)], '-k');
    plotH(i,2) = plot([v(t(i,2),1)+u(t(i,2)) v(t(i,3),1)+u(t(i,3))], ...
        [v(t(i,2),2)+u(t(i,2)+b) v(t(i,3),2)+u(t(i,3)+b)], '-k');  
    plotH(i,3) = plot([v(t(i,3),1)+u(t(i,3)) v(t(i,1),1)+u(t(i,1))], ...
        [v(t(i,3),2)+u(t(i,3)+b) v(t(i,1),2)+u(t(i,1)+b)], '-k');  
  end
  axis square;
end