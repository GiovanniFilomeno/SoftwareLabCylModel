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
polygon_list_save = polyshape.empty(length(y_values),0);

% Create all polygons at the cutting planes between the sections
% Define polygon directly in the cutting plane
for section_index = 1:length(y_values) % Note: length(y_values) is always length(mesh_list)+1
    
    y_section = y_values(section_index);
    
    if section_index == length(y_values)
        F = mesh_list{section_index-1,1};
        V = mesh_list{section_index-1,2};
        N = mesh_list{section_index-1,3};
        [polygon] = define_cut_polygon(F,V,N,y_section,tol_on_plane,tol_uniquetol,tol);
    elseif section_index == 1
        F = mesh_list{section_index,1};
        V = mesh_list{section_index,2};
        N = mesh_list{section_index,3};
        [polygon] = define_cut_polygon(F,V,N,y_section,tol_on_plane,tol_uniquetol,tol);
    else
        F = mesh_list{section_index-1,1};
        V = mesh_list{section_index-1,2};
        N = mesh_list{section_index-1,3};
        [polygon1] = define_cut_polygon(F,V,N,y_section,tol_on_plane,tol_uniquetol,tol);
        F = mesh_list{section_index,1};
        V = mesh_list{section_index,2};
        N = mesh_list{section_index,3};
        [polygon2] = define_cut_polygon(F,V,N,y_section,tol_on_plane,tol_uniquetol,tol);
        polygon = union(polygon1,polygon2);
    end

    %%
    polygon_list_save(section_index) = polygon;
end


%%
% Create maximum possible polygon in each section
for section_index = 1:length(y_values)-1
    F = mesh_list{section_index,1};
    V = mesh_list{section_index,2};
    N = mesh_list{section_index,3};
    polygon_left = polygon_list_save(section_index);
    polygon_right = polygon_list_save(section_index+1);
    y_min_section = y_values(section_index);
    y_max_section = y_values(section_index+1);
    [polygon] =  define_section_polygon(F,V,N,polygon_left,polygon_right,y_min_section,y_max_section,tol_on_plane);

    polygon_list{section_index} = polygon;

    % Plot polygon at the end
%     figure();
%     plot(polygon);
%     hold on
end
    
end
