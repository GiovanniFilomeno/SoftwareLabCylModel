% Function removes circles, which do not contribute much to the final area.
function [radii,X,Y,new_number_circles] = remove_circles(number_circles,radii,X,Y,min_points,max_points)

radii = radii(1:number_circles);
X = X(1:number_circles);
Y = Y(1:number_circles);
[radii,sorted_indices] = sort(radii,'ascend');
X = X(sorted_indices);
Y = Y(sorted_indices);
total_area = compute_area(X,Y,radii,number_circles-1,0,...
    [min_points(1),max_points(1)],[min_points(2),max_points(2)]);
previous_area = total_area;
new_number_circles = 0;
for i = 1:number_circles
    save_radius = radii(i);
    radii(i) = 0;
    new_area = compute_area(X,Y,radii,number_circles-1,0,...
        [min_points(1),max_points(1)],[min_points(2),max_points(2)]);
    if (new_area < 0.98*total_area) && ((new_area-previous_area) < 0.005*total_area)% Keep circle
        radii(i) = save_radius;
        new_number_circles = new_number_circles + 1;
    end
    previous_area = new_area;
end

end

