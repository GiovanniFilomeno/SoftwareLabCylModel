function [polygon_list, y_values] = define_2D_polygons(mesh_list, y_values)

% Creates the maximum possible 2D-polygon, which goes through each section

% polygon_list = [[P,P_end],[P,P_end],...] for each section (as input for
% the function "create_circles"
% y_values has length number_of_sections + 1 (each section bottom and top)

% Define some tolerances (attention, also defined in create_sections!!)
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
%     polygon_left = polygon_list_save(section_index);
%     polygon_right = polygon_list_save(section_index+1);
    polygon_left = define_cut_polygon(F,V,N,y_values(section_index),tol_on_plane,tol_uniquetol,tol);
    polygon_right = define_cut_polygon(F,V,N,y_values(section_index+1),tol_on_plane,tol_uniquetol,tol);
    y_min_section = y_values(section_index);
    y_max_section = y_values(section_index+1);
    [polygon] =  define_section_polygon(F,V,N,polygon_left,polygon_right,y_min_section,y_max_section,tol_on_plane);

    polygon_list{section_index} = polygon;

    % Plot polygon at the end
%     figure();
%     plot(polygon,'FaceColor','green');
end
    
end
