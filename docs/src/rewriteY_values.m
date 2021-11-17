function [new_y_values] = rewriteY_values(polygon_list, y_values, maximal_area_difference_ratio)

areas_polygon=zeros(length(polygon_list),1);
for i=1:length(polygon_list)
    areas_polygon(i) = area(polygon_list{i});
end

new_y_values = [y_values(1)];
area_current = areas_polygon(1);
polygon = polygon_list{1};
for i = 2:length(areas_polygon) % always one less than length(y_values)
    % Neglect, cut, if intersection of both polygons is more than 95%
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
        % Compare with new polygon and area
        area_current = areas_polygon(i);
        polygon = polygon_list{i};
    end
    % else, don't include the y_value and still compare with the same
    % element
end
new_y_values = [new_y_values,y_values(end)];

end
