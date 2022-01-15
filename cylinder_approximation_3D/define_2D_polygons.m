function [polygon_list, y_values] = define_2D_polygons(mesh_list, y_values)
% 
% define_2D_polygons creates the maximum possible 2D-polygon for each
% section. That means, the maximum polygon, such that an extrusion of this
% polygon in the section lies completely within the geometry
%
%Inputs:
%       :mesh_list: The geometry of each section, stl-like-datastructure. It
%                   consists of faces, vertices and normal vectors
%       :y_values: array of length mesh_list + 1, stores all y_values
%                  between the sections and at the ends of the complete geometry
%Outputs:
%       :polygon_list: list of length mesh_list including all computed
%                      2D-polygons used as input for the function create_circles
%       :y_values: the same as the input




% Define some tolerances (attention, also defined in create_sections_initial!!)
% Tolerances for polygon determination in section
tol_uniquetol = 1e-6;
tol = 1e-6;
tol_on_plane = 1e-6;

polygon_list = cell(1,length(y_values)-1);


%%
% Create maximum possible polygon in each section
for section_index = 1:length(y_values)-1
    F = mesh_list{section_index,1};
    V = mesh_list{section_index,2};
    N = mesh_list{section_index,3};
    % Define polygons at left and right cutting-plane
    polygon_left = define_cut_polygon(F,V,N,y_values(section_index),tol_on_plane,tol_uniquetol,tol);
    polygon_right = define_cut_polygon(F,V,N,y_values(section_index+1),tol_on_plane,tol_uniquetol,tol);
    y_min_section = y_values(section_index);
    y_max_section = y_values(section_index+1);
    % Define final polygon for the current section
    [polygon] =  define_section_polygon(F,V,N,polygon_left,polygon_right,y_min_section,y_max_section,tol_on_plane);

    polygon_list{section_index} = polygon;

    % Plot polygon at the end
%     figure();
%     plot(polygon,'FaceColor','green');
end
    
end
