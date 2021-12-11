function [polygon] = define_section_polygon(F,V,N,polygon_left,polygon_right,y_min_section,y_max_section,tol_on_plane)
% define_section_polygon creates the maximum possible polygon inside a
% given geometry. The constraint is, that an extrusion of the polygon along
% the y-axis through the geometry needs to lie completely inside the
% geometry. The polygons at the right and left cutting-planes of the
% geometry are given.
%| Inputs:
%         F,V,N: faces, vertices and normal-vectors of the given geometry
%         y_min_section, y_max_section: the x-z-plane at these y-values are
%         the cutting-planes at both ends of the given section
%         polygon_left,polygon_right: the polygons at the ends of the
%         section
%         tol_on_plane: a tolerance
%| Outputs:
%         polygon: the polygon as a polyshape-object

number_faces = size(F,1);
valid_faces = []; % use to remove faces, which lie exactly on the plane
% Delete triangles, which lie exactly on the plane
for i = 1:number_faces
    vertex_y_values = [V(F(i,1),2),V(F(i,2),2),V(F(i,3),2)];
    vertices_on_min = ismembertol(vertex_y_values,y_min_section,tol_on_plane*2);
    vertices_on_max = ismembertol(vertex_y_values,y_max_section,tol_on_plane*2);
    if (sum(vertices_on_min) ~= 3) && (sum(vertices_on_max) ~= 3)
        valid_faces = [valid_faces,i];
    end
end
F = F(valid_faces,:);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polygon = intersect(polygon_left,polygon_right);
% 

% % % figure();
% % % hold on
% % % plot(polygon)

%% Remove all triangles from polygon
if ~isempty(F)
    [triangle_region] = define_triangle_region(F,V);
%     plot(triangle_region);
    if ~isempty(triangle_region)
        polygon = subtract(polygon,triangle_region);
    end
end

% % % figure();
% % % hold on
% % % plot(polygon)

end

