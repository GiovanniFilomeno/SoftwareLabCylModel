function [polygone_list, y_values] = define_2D_polygones(mesh_list, y_values)

% polygone_list = [[P,P_end],[P,P_end],...] for each section (as input for
% the function "approximate_by_circles"
% y_values has length number_of_sections + 1 (each section bottom and top)

% Tolerances for polygone determination in section
tol_uniquetol = 1e-6;
tol = 1e-6;
tol_on_plane = 1e-2;

polygone_list = cell(1,length(y_values)-1);
polygone_list_save = polyshape.empty(length(y_values),0);

% Input section
for section_index = 1:length(y_values)
    if section_index == length(y_values)
        F = mesh_list{section_index-1,1};
        V = mesh_list{section_index-1,2};
        N = mesh_list{section_index-1,3};
    else
        F = mesh_list{section_index,1};
        V = mesh_list{section_index,2};
        N = mesh_list{section_index,3};
    end

    %%
    % Delete triangles, which lie exactly on the plane and
    % create line segments, if at least 2 vertices of a triangle lie on the
    % min-plane
    y_section = y_values(section_index);

    number_faces = size(F,1);
    valid_faces = []; % use to remove faces, which lie exactly on the plane
    number_lines = 0;
    start_nodes = zeros(2,number_faces);
    end_nodes = zeros(2,number_faces);
% Plot lines
% % %     figure();
% % %     hold on
    for i = 1:number_faces
        vertex_y_values = [V(F(i,1),2),V(F(i,2),2),V(F(i,3),2)];
        vertices_on_plane = ismembertol(vertex_y_values,y_section,tol_on_plane);
%         if sum(vertices_on_min) == 3
% %             vertex_x_values = [V(F(i,1),1),V(F(i,2),1),V(F(i,3),1)];
% %             vertex_z_values = [V(F(i,1),3),V(F(i,2),3),V(F(i,3),3)];
% %             vertex_x_values = vertex_x_values(vertices_on_min);
% %             vertex_z_values = vertex_z_values(vertices_on_min);
%             start_nodes(:,number_lines+1:number_lines+3) = [V(F(i,1),1),V(F(i,2),1),V(F(i,3),1);V(F(i,1),3),V(F(i,2),3),V(F(i,3),3)];
%             end_nodes(:,number_lines+1:number_lines+3) = [V(F(i,3),1),V(F(i,1),1),V(F(i,2),1);V(F(i,3),3),V(F(i,1),3),V(F(i,2),3)];
%             number_lines = number_lines + 3;
%         end
        if sum(vertices_on_plane) == 2
            number_lines = number_lines + 1;
            vertex_x_values = [V(F(i,1),1),V(F(i,2),1),V(F(i,3),1)];
            vertex_z_values = [V(F(i,1),3),V(F(i,2),3),V(F(i,3),3)];
            vertex_x_values = vertex_x_values(vertices_on_plane);
            vertex_z_values = vertex_z_values(vertices_on_plane);
% % %             plot(vertex_x_values,vertex_z_values,'Color','k');
            start_nodes(:,number_lines) = [vertex_x_values(1);vertex_z_values(1)];
            end_nodes(:,number_lines) = [vertex_x_values(2);vertex_z_values(2)];
        end
    end
    
    
    
    % These are now all lines on the cutting planes:
    start_nodes = start_nodes(:,1:number_lines)';
    end_nodes = end_nodes(:,1:number_lines)';

    %%
    % Create a polygone from the lines using a graph
    nodes = [start_nodes; end_nodes];
    nodes = uniquetol(nodes,tol_uniquetol,'ByRows',true);
    nodes = sortrows(nodes,[1 2]);
    [~, n1] = ismembertol(start_nodes, nodes, tol, 'ByRows',true);
    [~, n2] = ismembertol(end_nodes, nodes, tol,  'ByRows',true);
    conn1 = [n1 n2];
    G = graph(conn1(:,1),conn1(:,2));
    %Plot graph
% % %     figure();
% % %     plot(G);
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
    %Plot polygon
% % %     figure();
% % %     plot(polygon);
% % %     hold on
    polygone_list_save(section_index) = polygon;
end


%%
for section_index = 1:length(y_values)-1
    F = mesh_list{section_index,1};
    V = mesh_list{section_index,2};
    N = mesh_list{section_index,3};
    number_faces = size(F,1);
    valid_faces = []; % use to remove faces, which lie exactly on the plane
    y_min_section = y_values(section_index);
    y_max_section = y_values(section_index+1);
    for i = 1:number_faces
        vertex_y_values = [V(F(i,1),2),V(F(i,2),2),V(F(i,3),2)];
        vertices_on_min = ismembertol(vertex_y_values,y_min_section,tol_on_plane);
        vertices_on_max = ismembertol(vertex_y_values,y_max_section,tol_on_plane);
        if (sum(vertices_on_min) ~= 3) && (sum(vertices_on_max) ~= 3)
            valid_faces = [valid_faces,i];
        end
    end
    F = F(valid_faces);
    polygon = intersect(polygone_list_save(section_index),polygone_list_save(section_index+1));
    %% Remove all triangles from polygon
    number_triangles = size(F,1);
    polyvec_triangles = polyshape.empty(number_triangles,0);
    for i=1:number_triangles
        polyvec_triangles(i) = polyshape([V(F(i,1),1),V(F(i,2),1),V(F(i,3),1)], [V(F(i,1),3),V(F(i,2),3),V(F(i,3),3)]);
        % plot(triangle);
    end
    triangle_region = union(polyvec_triangles);
    polygon = subtract(polygon,triangle_region);

    % Plot polygon at the end
%     figure();
%     plot(polygon);
%     hold on

    %%
    polygone_list{section_index} = polygon;
end
    
end
