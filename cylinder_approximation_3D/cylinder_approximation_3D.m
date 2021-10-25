clc; clear; close all;
profile off;
% delete(gcp('nocreate'));
% parpool('local');
warning('off','MATLAB:polyshape:boolOperationFailed');
warning('off','MATLAB:polyshape:repairedBySimplify');
warning('off','MATLAB:polyshape:boundary3Points');
profile on;


% [v, f, n, name] = stlReadFirst("Baumraum example complex.stl");
% stlWrite('neubauraum.stl',f,v);
% stl_file = "neubauraum.stl";
stl_file = "Pyramid Shape.stl";
[F,V,N] = stlread(stl_file);
disp("Number of faces in stl-file: "+string(size(F,1)));
if size(F,1) <= 280%6088%280
    number_of_sections = 25;
    [mesh_list, y_values] = create_sections(F,V,N,number_of_sections);

    [polygone_list, y_values] = define_2D_polygones(mesh_list, y_values);
    
    [cylinders,cylinders_red] = create_cylinders(polygone_list, y_values);

    plot_cylinders(cylinders,cylinders_red,y_values);
    print_STL(V,F);
    axis equal;
    view([1 1 1]);
else
    "Too large 3D object, too many triangles"
end
