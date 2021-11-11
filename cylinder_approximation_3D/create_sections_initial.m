% This function generates y_values, and cuts the geometry into according
% sections. It chooses the y_values, such that they make sense at the 2
% ends of the geometry. Furthermore, it places cuts at y_values, where many
% triangles are parallel to the y-plane. At the end, it defines the
% y_values, such that the thickness of each section is at most delta =
% (ymax-ymin)/number_of_sections
function [mesh_list, y_values, F_return, V_return, N_return] = create_sections_initial(F,V,N,number_of_sections,area_percentage_parallel,ends_offset_fraction)

% Define some tolerances (attention, also defined in define_2D_polygons!!)
tol_uniquetol = 1e-6;
tol = 1e-6;
tol_on_plane = 1e-6;

YminGEO=min(V(:,2));
YmaxGEO=max(V(:,2));
delta=(YmaxGEO-YminGEO)/(number_of_sections);

y_values = [];

F_return = F;
V_return = V;
N_return = N;

%%
% Check, if left and right end of geometry should be included.
% For that, check, wether a polygon with nonzero area can be defined at
% the left and right end.
% If not, cut the left or right end of the geometry.
% At the end, the ends will be included, as they will always have an area
% after this procedure.
[polygon_left] = define_cut_polygon(F_return,V_return,N_return,YminGEO,tol_on_plane,tol_uniquetol,tol);
if ~area(polygon_left)
    YminGEO = YminGEO + delta*ends_offset_fraction;
    [~,~,~,F_return,V_return,N_return]=cut_the_geometry(F_return,V_return,N_return,YminGEO);
end
[polygon_right] = define_cut_polygon(F_return,V_return,N_return,YmaxGEO,tol_on_plane,tol_uniquetol,tol);
if ~area(polygon_right)
    YmaxGEO = YmaxGEO - delta*ends_offset_fraction;
    [F_return,V_return,N_return,~,~,~]=cut_the_geometry(F_return,V_return,N_return,YmaxGEO);
end
delta=(YmaxGEO-YminGEO)/(number_of_sections);

%%
% Find planes, which are perpendicular to the y-axis
% First compute total area
[triangle_region] = define_triangle_region(F,V);
total_crossectional_area = area(triangle_region);

% Then find all faces parallel to the y-plane
number_faces = size(F,1);
parallel_faces = [];
y_values_parallel = [];
for i = 1:number_faces
    vertex_y_values = [V(F(i,1),2),V(F(i,2),2),V(F(i,3),2)];
    if (ismembertol(vertex_y_values(1),vertex_y_values(2),tol_on_plane/2)) && (ismembertol(vertex_y_values(2),vertex_y_values(3),tol_on_plane/2))
        parallel_faces = [parallel_faces,i];
        y_values_parallel = [y_values_parallel,mean(vertex_y_values)];
    end
end
F_parallel = F(parallel_faces,:);
[y_values_parallel,sorted_index] = sort(y_values_parallel);
F_parallel = F_parallel(sorted_index,:);

if ~isempty(y_values_parallel)
    % Add y_values, if at that y_value, the area of the parallel triangle
    % exceeds a given percentage of the total area.
    y_value = y_values_parallel(1);
    triangles = F_parallel(1,:);
    for i = 2:length(y_values_parallel)
        % Still at the same plane
        if ismembertol(y_values_parallel(i),y_value,tol_on_plane/2)
            triangles = [triangles;F_parallel(i,:)];
        else % At the new plane
            % First handle triangles of previous plane
            [triangle_region] = define_triangle_region(triangles,V);
            area_y = area(triangle_region);
            if area_y >= area_percentage_parallel*total_crossectional_area
                y_values = [y_values,y_value];
            end
            % Start new plane
            y_value = y_values_parallel(i);
            triangles = F_parallel(i,:);
        end
    end
    [triangle_region] = define_triangle_region(triangles,V);
    area_y = area(triangle_region);
    if area_y >= area_percentage_parallel*total_crossectional_area
        y_values = [y_values,y_value];
    end
end

%%
% Add the ends of the geometry to y_values, if they are not already included
if ~sum(ismembertol(YminGEO,y_values,tol_uniquetol))
    y_values = [YminGEO,y_values];
end
if ~sum(ismembertol(YmaxGEO,y_values,tol_uniquetol))
    y_values = [y_values,YmaxGEO];
end
y_values = sort(y_values);

%%
% Add sections, such that the maximal thickness of a section is delta, 
% which is defined by the parameter "number_of_sections"
for i = 1:length(y_values)-1
    distance = y_values(i+1)-y_values(i);
    if distance > delta
        number_new_sections = ceil(distance/delta);
        new_y_values = linspace(y_values(i),y_values(i+1),number_new_sections+1);
        new_y_values = new_y_values(2:end-1); % Endpoints excluded
        y_values = [y_values,new_y_values];
    end
end

y_values = sort(y_values);
mesh_list = cell(length(y_values)-1,3);

%%
% Do the actual cuttings
F = F_return;
V = V_return;
N = N_return;
for i=1:(length(y_values)-2)
    
    [FGR,VGR,NGR,FRD,VRD,NRD]=cut_the_geometry(F,V,N,y_values(i+1));

    mesh_list{i,1}=FGR;
    mesh_list{i,2}=VGR;
    mesh_list{i,3}=NGR;

    F=FRD;
    V=VRD;
    N=NRD;

    if i==(length(y_values)-2)
        mesh_list{i+1,1}=FRD;
        mesh_list{i+1,2}=VRD;
        mesh_list{i+1,3}=NRD;
    end

end

% for i=1:(length(y_values)-1)
%     figure();
%     plot_STL(mesh_list{i,2},mesh_list{i,1});
%     axis equal;
% end

end