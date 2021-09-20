clc; clear; close all;

 F = [];
 V = [];
 N = [];
 number_of_sections = 0;
 [mesh_list, y_values] = create_sections(F,V,N,number_of_sections);

 % mesh_list = [];
 %y_values = [0, 50, 150, 190, 300, 400, 550, 600];
 
 figure();
[polygone_list, y_values] = define_2D_polygones(mesh_list, y_values);

% Task 3: (I use dummy input in the function itself
%[cylinders,cylinders_red] = create_cylinders([],[]); % polygone_list, y_values);

% plot_cylinders(cylinders);
