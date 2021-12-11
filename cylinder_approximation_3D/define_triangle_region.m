function [triangle_region] = define_triangle_region(F,V)
% define_triangle_region creates a polyshape as the union of several 
% triangles (all in 2D)
%| Inputs:
%         F,V: faces, and vertices of all triangles
%| Outputs:
%         triangle_region: final polygon given as polyshape-object

number_triangles = size(F,1);
polyvec_triangles = polyshape.empty(number_triangles,0);
for i=1:number_triangles
    polyvec_triangles(i) = polyshape([V(F(i,1),1),V(F(i,2),1),V(F(i,3),1)], [V(F(i,1),3),V(F(i,2),3),V(F(i,3),3)]);
%     plot(triangle);
end
areas_triangles = area(polyvec_triangles);
polyvec_triangles = polyvec_triangles(areas_triangles > 0);
if ~isempty(polyvec_triangles)
    triangle_region = union(polyvec_triangles);
else
    triangle_region = polyshape.empty(1,0);
end
end

