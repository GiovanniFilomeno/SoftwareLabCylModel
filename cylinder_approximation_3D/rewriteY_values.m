function [new_y_values] = rewriteY_values(polygon_list, y_values, maximal_area_difference_ratio)
% 
% rewriteY_values checks, which y_values are needed and only returns these
% y_values. The given polygon_list and y_values approximate a geometry,
% which has been cut into several sections. If 2 polygons only differ
% slightly, the cut between them is not necessary and the y_value at that
% position is removed. The measurement, how different 2 polygons are, is
% based on the ratio of the area of the intersection divided by the area of
% the union of these 2 polygons.
%
%Inputs:
%         :polygon_list: list of all polygons, that should be compared
%         :y_values: list of y-values (length polygon_list + 1). Between 2
%                    y-values, the geometry is defined by the according polygon.
%         :maximal_area_difference_ratio: if the ratio of the area of the
%                                         intersection and the union of 2 polygons is smaller than this
%                                         value, then they are concidered to be very different and both are
%                                         needed, to approximate the geometry.
%Outputs:
%         :new_y_values: the y-values, that remain, after some unnecessary
%                        ones have been removed.

areas_polygon=zeros(length(polygon_list),1);
for i=1:length(polygon_list)
    areas_polygon(i) = area(polygon_list{i});
end

new_y_values = [y_values(1)];
area_current = areas_polygon(1);
polygon = polygon_list{1};
for i = 2:length(areas_polygon) % always one less than length(y_values)
    if area_current && areas_polygon(i)
        intersection = intersect(polygon,polygon_list{i});
        united_area = union(polygon,polygon_list{i});
        area_intersected = area(intersection);
        area_union = area(united_area);
        ratio = area_intersected/area_union;
    else
        ratio = 0;
    end
    
    if ratio <= maximal_area_difference_ratio % area very different, include the cut between these areas
        new_y_values = [new_y_values,y_values(i)];
        % Compare next polygons with new polygon and area
        area_current = areas_polygon(i);
        polygon = polygon_list{i};
    end
    % else, don't include the y_value and still compare with the same
    % element
end
new_y_values = [new_y_values,y_values(end)];

end
