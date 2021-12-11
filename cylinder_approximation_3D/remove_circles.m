function [radii,X,Y] = remove_circles(radii,X,Y,radii_red,X_red,Y_red,radii_stay,X_stay,Y_stay,min_area_remain,max_area_removed)
% remove_circles deletes circles, which do not contribute much to the final
% area of a given shape. The shape consists of the addition of (green)
% circles and the subtraction of (red) circles. Some green circles may be
% removed. Some other green circles always remain. The circles are only
% removed, if the area after the removal compared to the initial area
% retains a minimum value and if the difference of the areas before and
% after the removal of a circle is sufficiently small.
%| Inputs:
%         X,Y,radii: vectors of center-coordinates and radii of circles,
%         which are combined to a single shape. Some of these circles will
%         be removed.
%         X_red,Y_red, radii_red: vectors of center-coordinates and radii
%         of circles, which are subtracted from the shape
%|        X_stay,Y_stay,radii_stay: vectors of center-coordinates and radii
%         of green circles, which are added to the shape. None of these
%         circles will be removed.
%|        min_area_remain: At least this fraction of the initial area has 
%         to remain after the circles are removed.
%         max_area_removed: Each circle, that is removed, may only decrease
%         the area by this fraction of the initial area.
%| Outputs:
%         X,Y,radii: vectors of center-coordinates and radii of circles,
%         which are combined to a single shape. These are all circles, that
%         remain after some others have been removed.

if nargin < 11
    % Parameters, that can be used to tune the result:
    % Minimum remaining area:
    min_area_remain = 0.9995; % Higher=More accurate
    % Maximum area removed for one circle:
    max_area_removed = 0.00005; % Lower=More accurate
end

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

