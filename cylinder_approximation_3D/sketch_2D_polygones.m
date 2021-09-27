function sketch_2D_polygones(mesh_list, y_values)

% polygone_list = [[P,P_end],[P,P_end],...] for each section (as input for
% the function "approximate_by_circles"
% y_values has length number_of_sections + 1 (each section bottom and top)
figure();
i = 3;
F = mesh_list{i,1};
V = mesh_list{i,2};
N = mesh_list{i,3};

number_triangles = size(F,1);
for i=1:number_triangles
    
    fill([V(F(i,1),1),V(F(i,2),1),V(F(i,3),1),V(F(i,1),1)], [V(F(i,1),3),V(F(i,2),3),V(F(i,3),3),V(F(i,1),3)] , 'blue');
   % plot( polygone_list{(V(F(j,1))),3}, polygone_list{(V(F(j,2))),2}, 'blue');
    hold on
end

end