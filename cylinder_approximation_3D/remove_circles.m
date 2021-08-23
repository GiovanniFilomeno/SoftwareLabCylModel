% Function removes circles, which do not contribute much to the final area.
function [radii,X,Y] = remove_circles(radii,X,Y,X_red,Y_red,radii_red,min_points,max_points)

[radii,sorted_indices] = sort(radii,'ascend');
X = X(sorted_indices);
Y = Y(sorted_indices);
total_area = compute_area(X,Y,radii,X_red,Y_red,radii_red,...
    [min_points(1),max_points(1)],[min_points(2),max_points(2)]);
previous_area = total_area;

number_circles = length(radii);
for i = 1:number_circles
    save_radius = radii(i);
    radii(i) = 0;
    new_area = compute_area(X,Y,radii,X_red,Y_red,radii_red,...
        [min_points(1),max_points(1)],[min_points(2),max_points(2)]);
    if (new_area < 0.98*total_area) && ((new_area-previous_area) < 0.005*total_area)% Keep circle
        radii(i) = save_radius;
    end
    previous_area = new_area;
end

remaining_indices = find(radii);
X = X(remaining_indices);
Y = Y(remaining_indices);
radii = radii(remaining_indices);

end

