% Defines a polygone at a certain cutting plane of an stl-file.
% stl-file.
function [polygon] = define_cut_polygon(F,V,N,y_value,tol_on_plane,tol_uniquetol,tol)

number_faces = size(F,1);
number_lines = 0;
start_nodes = zeros(2,number_faces);
end_nodes = zeros(2,number_faces);
% Plot lines
% % %     figure();
% % %     hold on

% Create line segments, if exactly 2 vertices of a triangle lie on the
% min-plane
for i = 1:number_faces
    vertex_y_values = [V(F(i,1),2),V(F(i,2),2),V(F(i,3),2)];
    vertices_on_plane = ismembertol(vertex_y_values,y_value,tol_on_plane);
    if sum(vertices_on_plane) == 2
        number_lines = number_lines + 1;
        vertex_x_values = [V(F(i,1),1),V(F(i,2),1),V(F(i,3),1)];
        vertex_z_values = [V(F(i,1),3),V(F(i,2),3),V(F(i,3),3)];
        vertex_x_values = vertex_x_values(vertices_on_plane);
        vertex_z_values = vertex_z_values(vertices_on_plane);
% % %         plot(vertex_x_values,vertex_z_values,'Color','k');
        start_nodes(:,number_lines) = [vertex_x_values(1);vertex_z_values(1)];
        end_nodes(:,number_lines) = [vertex_x_values(2);vertex_z_values(2)];
    end
end
% disp(number_lines)



% These are now all lines on the cutting planes:
start_nodes = start_nodes(:,1:number_lines)';
end_nodes = end_nodes(:,1:number_lines)';

%%
% Create a polygon from the lines using a graph
nodes = [start_nodes; end_nodes];
nodes = uniquetol(nodes,tol_uniquetol,'ByRows',true);
nodes = sortrows(nodes,[1 2]);
[~, n1] = ismembertol(start_nodes, nodes, tol, 'ByRows',true);
[~, n2] = ismembertol(end_nodes, nodes, tol,  'ByRows',true);
conn1 = [n1 n2];
G = graph(conn1(:,1),conn1(:,2));
% Plot graph
% % % figure();
% % % plot(G);
bins = conncomp(G);
x_values_polygon = cell(1,max(bins));
z_values_polygon = cell(1,max(bins));
for i = 1: max(bins)
    startNode = find(bins==i, 1, 'first');
    path = dfsearch(G, startNode);
    x_values_polygon{i} = nodes(path,1);
    z_values_polygon{i} = nodes(path,2);
end
polygon = polyshape(x_values_polygon,z_values_polygon,'Simplify',true);
% % % figure();
% % % plot(polygon);
% % % hold on

end

