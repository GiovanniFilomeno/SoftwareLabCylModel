function [volume_approximated] = plot_cylinders(cylinders,cylinders_red,y_values)
% plot_cylinders plots some parallel cylinders in a 3D-space by approximating
% the corresponding circles as polygons.
% It includes cylinders, which are added (green) and subtracted (red).
% Between 2 y-values (in one section), there are always the same cylinders.
% As the area of each crossection is given in the process also the volume
% of the cylinder-geometry is computed and returned.
%| Inputs:
%|         cylinders: list of all cylinders, which are added to the geometry.
%          It consists of the coordinates for both endpoints of the cylinders 
%          and the radius
%|         cylinders_red: list of all cylinders, which are subtracted from
%          the geometry. Same structure, as cylinders
%|         y_values: between these y-values, the crossections are constant
%| Outputs:
%|         volume_approximated: volume of the given cylinder-geometry

volume_approximated = 0;

figure();
axis equal

centers_left = cylinders{1,1};
centers_right = cylinders{1,2};
cylinder_radii = cylinders{1,3};
centers_left_red = cylinders_red{1,1};
centers_right_red = cylinders_red{1,2};
cylinder_radii_red = cylinders_red{1,3};
number_green_cylinders = length(cylinder_radii);
number_red_cylinders = length(cylinder_radii_red);

for y_index = 1:length(y_values)-1
    y = (y_values(y_index)+y_values(y_index+1))/2;
    X = zeros(1,number_green_cylinders);
    Z = zeros(1,number_green_cylinders);
    radii = zeros(1,number_green_cylinders);
    for i = 1:number_green_cylinders
        if (y>=centers_left(i,2)) && (y<=centers_right(i,2))
            X(i) = centers_left(i,1);
            Z(i) = centers_left(i,3);
            radii(i) = cylinder_radii(i);
        end
    end
    X_red = zeros(1,number_red_cylinders);
    Z_red = zeros(1,number_red_cylinders);
    radii_red = zeros(1,number_red_cylinders);
    for i = 1:number_red_cylinders
        if (y>=centers_left_red(i,2)) && (y<=centers_right_red(i,2))
            X_red(i) = centers_left_red(i,1);
            Z_red(i) = centers_left_red(i,3);
            radii_red(i) = cylinder_radii_red(i);
        end
    end
    [~,index_red] = find(radii_red);
    [~,index_green] = find(radii);
    y_positions = [y_values(y_index),y_values(y_index+1)];%linspace(y_values(y_index),y_values(y_index+1),number_per_section);
    area_section = plot_circles(radii(index_green),X(index_green),Z(index_green),radii_red(index_red),X_red(index_red),Z_red(index_red),y_positions);
    volume_approximated = volume_approximated + area_section*(y_positions(end)-y_positions(1));
end

view([1,1,1])

end


