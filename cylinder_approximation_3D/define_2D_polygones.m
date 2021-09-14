function [polygone_list, y_values] = define_2D_polygones(mesh_list, y_values)

% polygone_list = [[P,P_end],[P,P_end],...] for each section (as input for
% the function "approximate_by_circles"
% y_values has length number_of_sections + 1 (each section bottom and top)

F = mesh_list{3,1};
V = mesh_list{3,2};
N = mesh_list{3,3};

number_triangles = size(F,1);
polygone_list = [];

hold on
for i = 1:number_triangles
     fill([V(F(i,1),2),V(F(i,2),2),V(F(i,3),2),V(F(i,1),2)],[V(F(i,1),3),V(F(i,2),3),V(F(i,3),3),V(F(i,1),3)],'blue')
end

end

