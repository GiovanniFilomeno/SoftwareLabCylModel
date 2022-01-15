function [lines_on_hull,inner_point] = find_lines_on_hull(P,P_end)
%
% find_lines_on_hull returns lines of a polygon, which are also part of the
%sconvex hull of that polygon.
%
%Inputs:
%        :P: array of all points of the polygon
%        :P_end: array of points, that has the same length as P. Together with P,
%                this defines all edges of the polygon.
%Outputs:
%        :lines_on_hull: logical array, which is one, 
%                         if the corresponding line lies on the convex hull
%        :inner_point: average point of the convex hull, 
%                      which is guaranteed to lie inside the convex hull

number_points = length(P);

k = convhull(P);
k_end = convhull(P_end);
inner_point = mean(P(k,:),1); % always inside the convex polygon
point_numbers = 1:number_points;
points_on_hull = ismember(point_numbers,k);
points_on_hull_end = ismember(point_numbers,k_end);

lines_on_hull = points_on_hull&points_on_hull_end;

mid_points = (P+P_end)/2;
check_points = [P;mid_points];
check_mids = convhull(check_points);
mid_numbers = 1:length(check_points);
mids_on_hull_index = ismember(mid_numbers,check_mids);

for i = 1:number_points
    if mids_on_hull_index(i+number_points) == 0
        lines_on_hull(i) = 0;
    end
end

end

