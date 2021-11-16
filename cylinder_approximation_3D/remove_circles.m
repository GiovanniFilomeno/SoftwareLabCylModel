% Function removes circles, which do not contribute much to the final area.
function [radii,X,Y] = remove_circles(radii,X,Y,radii_red,X_red,Y_red,min_points,max_points,radii_stay,X_stay,Y_stay)

% Parameters, that can be used to tune the result:
% Minimum remaining area:
min_area_remain = 0.9995; % Higher=More accurate
% Maximum area removed for one circle:
max_area_removed = 0.00005; % Lower=More accurate

% The circels with parameters ending with _stay will not be removed
if ~exist('radii_stay','var')
    radii_stay = [];
    X_stay = [];
    Y_stay = [];
end

[radii,sorted_indices] = sort(radii,'ascend');
X = X(sorted_indices);
Y = Y(sorted_indices);
total_area = compute_area3([X;X_stay],[Y;Y_stay],[radii;radii_stay],X_red,Y_red,radii_red);%,...
    %[min_points(1),max_points(1)],[min_points(2),max_points(2)]);
previous_area = total_area;

number_circles = length(radii);
for i = 1:number_circles
    save_radius = radii(i);
    radii(i) = 0;
    new_area = compute_area3([X;X_stay],[Y;Y_stay],[radii;radii_stay],X_red,Y_red,radii_red);%,...
        %[min_points(1),max_points(1)],[min_points(2),max_points(2)]);
    if (new_area < min_area_remain*total_area) && ((new_area-previous_area) < max_area_removed*total_area)% Keep circle
        radii(i) = save_radius;
    end
    previous_area = new_area;
end

remaining_indices = find(radii);
X = X(remaining_indices);
Y = Y(remaining_indices);
radii = radii(remaining_indices);

end

