% An stl_file is approximated by parallel cylinders (parallel to the y-axis)
% the cylinders must not lie outside of the initial geometry
%
% first, y_values are chosen, where geometry is cut.
% second, new stl-files are defined for every section in between the cuts.
% third, maximum allowable 2D-polygon is defined for each section
% fourth, cylinders are created, using a 2D-algorithm with circles and
% reusing cylinders, whenever possible

clc; clear; close all;
profile off;
% delete(gcp('nocreate'));
% parpool('local');
warning('off','MATLAB:polyshape:boolOperationFailed');
warning('off','MATLAB:polyshape:repairedBySimplify');
warning('off','MATLAB:polyshape:boundary3Points');
% profile on;


% [v, f, n, name] = stlReadFirst("Baumraum example complex.stl");
% stlWrite('neubauraum.stl',f,v);
% stl_file = "neubauraum.stl";
stl_file = "Hexagon Shape.stl";
[F,V,N] = stlread(stl_file);
disp("Number of faces in stl-file: "+string(size(F,1)));
if size(F,1) <= 6088%280
    %%
    % Parameters which influence the approximation:
    % Parameters for create_sections_initial:
    number_of_sections = 20; % defines maximum thickness of every section
    % by setting thickness > (max(y)-min(y))/number_of_sections
    area_percentage_parallel = 0.05; % If a part of the goemetry with an
    % area of more than this value is parallel to the y-plane, then the
    % corresponding y-value will be included as a position for a cut.
    ends_offset_fraction = 0.2; % If there is no 2D-polygon at the ends of
    % the geometry, which is parallel to the y-plane, than the geometry is
    % cut at a certain offset. This offset is the maximum thickness delta
    % times this fraction.
    
    % Parameters for rewriteY_values:
    maximal_area_difference_ratio = 0.97; % If the ratio of intersection/union
    % of 2 polygons is smaller or equal to that value, than they are
    % regarded as very different and the corresponding cut remains.
    
    % Parameters for create_cylinders/create_circles:
    number_circles_per_section = 40; % maximum number of circles, that are
    % defined at every 2D-polygon
    red_radius_factor = 20; % Relative radius of red cylinders, which are
    % subtracted from the geometry. The higher, the more accurate in
    % theory, but there may be some numerical difficulties
    
    % Further parameters, that can be set in the functions:
    % -Some tolerances in create_sections_initial and define_2D_polygons
    % -accuracy_factor in remove_circles_proximity
    % -area criteria in remove_circles
    
    %%
    % Start of the actual approximation steps:
    % Initial slicing
    [mesh_list, y_values, F, V, N] = create_sections_initial(F,V,N,number_of_sections,area_percentage_parallel,ends_offset_fraction);

    [polygon_list, y_values] = define_2D_polygons(mesh_list, y_values);
    
    [new_y_values] = rewriteY_values(polygon_list, y_values, maximal_area_difference_ratio);
    
    % Adapted slicing 
    [mesh_list, new_y_values] = create_sections(F,V,N,new_y_values);
    
    [polygon_list, new_y_values] = define_2D_polygons(mesh_list, new_y_values);

    [cylinders,cylinders_red] = create_cylinders(polygon_list, new_y_values, number_circles_per_section, red_radius_factor);
    plot_cylinders(cylinders,cylinders_red,new_y_values);
%     axis off
%     plot_STL(V,F,"none");
    axis equal;
    view([1 1 1]);
else
    disp("Too large 3D object, too many triangles");
end


% disp("Total number of green cylinders: "+string(length(cylinders{1,3})));
% disp("Total number of red   cylinders: "+string(length(cylinders_red{1,3})));
% profile off;
% profile viewer;
