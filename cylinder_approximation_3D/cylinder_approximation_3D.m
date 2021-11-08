clc; clear; close all;
profile off;
% delete(gcp('nocreate'));
% parpool('local');
warning('off','MATLAB:polyshape:boolOperationFailed');
warning('off','MATLAB:polyshape:repairedBySimplify');
warning('off','MATLAB:polyshape:boundary3Points');
% profile on;


[v, f, n, name] = stlReadFirst("Baumraum example complex.stl");
stlWrite('neubauraum.stl',f,v);
stl_file = "neubauraum.stl";
% stl_file = "simple_cube.stl";
[F,V,N] = stlread(stl_file);
disp("Number of faces in stl-file: "+string(size(F,1)));
if size(F,1) <= 6088%280
    number_of_sections = 10;
    
    % Homogeneous slicing 
    [mesh_list, y_values] = create_sections_test(F,V,N,number_of_sections);

%     [polygone_list, y_values] = define_2D_polygones(mesh_list, y_values);
    
%     [new_y_values] = rewriteY_values(polygone_list, y_values);
%     
%     % Adaptive slicing 
%     [mesh_list, new_y_values] = create_sections(F,V,N,new_y_values);
%     
%     [polygone_list, new_y_values] = define_2D_polygones(mesh_list, new_y_values);
   

% %     [cylinders,cylinders_red] = create_cylinders(polygone_list, new_y_values);
%     [cylinders,cylinders_red] = create_cylinders(polygone_list, y_values);
% 
% %     plot_cylinders(cylinders,cylinders_red,new_y_values);
%     plot_cylinders(cylinders,cylinders_red,y_values);
%     axis off
%     print_STL(V,F,"none");
%     axis equal;
%     view([1 1 1]);
else
    disp("Too large 3D object, too many triangles");
end


% disp("Total number of green cylinders: "+string(length(cylinders{1,3})));
% disp("Total number of red   cylinders: "+string(length(cylinders_red{1,3})));

% profile off;
% profile viewer;
