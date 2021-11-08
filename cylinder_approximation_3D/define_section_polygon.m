function [polygon] = define_section_polygon(F,V,N,polygon_left,polygon_right,y_min_section,y_max_section,tol_on_plane)
% Create maximum possible polygone inside the stl-file defined by F,V,N,
% assuming that the polygone at the right and left is given.

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
    polygon = subtract(polygon,triangle_region);
end

% % % figure();
% % % hold on
% % % plot(polygon)

end

