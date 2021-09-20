function [polygone_list, y_values] = define_2D_polygones(mesh_list, y_values)

% polygone_list = [[P,P_end],[P,P_end],...] for each section (as input for
% the function "approximate_by_circles"
% y_values has length number_of_sections + 1 (each section bottom and top)

for i = 1: 7 %loop for 7 number of sections
    
    p = [];
    p_end = [];

polygone_list = [];
y_values = [0, 50, 150, 190, 300, 400, 550, 600];
%y_values = [-20 -15 -5 5 15 20];

 F = mesh_list{i,1};
 V = mesh_list{i,2};
 N = mesh_list{i,3};
 
 for i=1:length(polygone_list)
    polygone = polygone_list{i};
    P = polygone{1};
    P_end = polygone{2};
end

number_triangles = size(F,1);

for i=1:(length(y_values)-2)
 
polygone_list{i,1}= F;
polygone_list{i,2}= V;
polygone_list{i,3}= N;


if i== (length(y_values)-2)
    polygone_list{i+1,1}= F;
    polygone_list{i+1,2}= V;
    polygone_list{i+1,3}= N;
end
for i=1:number_triangles
    
    plot([(V(F(i,1),2)),V(F(i,2),2),V(F(i,3),2),V(F(i,1),2)], [V(F(i,1),3),V(F(i,2),3),V(F(i,3),3),V(F(i,1),3)] , 'blue');
   % plot( polygone_list{(V(F(j,1))),3}, polygone_list{(V(F(j,2))),2}, 'blue');
    hold on
end

end

end
