clc; clear; close all;

% warning('off','MATLAB:polyshape:boolOperationFailed');
% warning('off','MATLAB:polyshape:repairedBySimplify');
% warning('off','MATLAB:polyshape:boundary3Points');

stl_file = "simple_cube.stl";
[F,V,N] = stlread(stl_file);
disp("Number of faces in stl-file: "+string(size(F,1)));
if size(F,1) <= 280
    number_of_sections=7;
    [mesh_list, y_values] = create_sections(F,V,N,number_of_sections);

    [polygone_list, y_values] = define_2D_polygones(mesh_list, y_values);
    %sketch_2D_polygones(mesh_list, y_values);

    [cylinders,cylinders_red] = create_cylinders(polygone_list, y_values);

    plot_cylinders(cylinders,cylinders_red,stl_file);
    print_STL(V,F);
else
    "Too large 3D object, too many triangles"
end