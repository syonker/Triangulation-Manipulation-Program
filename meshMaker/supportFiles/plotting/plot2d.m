
%Name: 
%    plot2d
%
%Purpose: 
%    This program draws two dimensional triangle meshes 
%
%Parameters:
%    t - (#triangles x 3) triangle matrix giving each triangle's three vertex numbers
%    v - (#vertices x 2) vertex matrix giving each vertex's X and Y coordinates
%
%Return Values:
%    plotH - a plot handle
%
%Author:
%    Shea Yonker
%
%Date:
%    09/18/2017

function [plotH] = plot2d(t,v)
  hold on;
  n=size(t,1);
  plotH = zeros(size(t,1),3);
  for i=1:n
    plotH(i,1) = plot([v(t(i,1),1) v(t(i,2),1)], [v(t(i,1),2) ...
                                                    v(t(i,2),2)], '-k');
    plotH(i,2) = plot([v(t(i,2),1) v(t(i,3),1)], [v(t(i,2),2) ...
                                                    v(t(i,3),2)], '-k');
    plotH(i,3) = plot([v(t(i,3),1) v(t(i,1),1)], [v(t(i,3),2) ...
                                                    v(t(i,1),2)], '-k');
  end
  axis square;
end