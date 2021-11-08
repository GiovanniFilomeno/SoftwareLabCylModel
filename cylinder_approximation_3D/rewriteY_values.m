function [new_y_values] = rewriteY_values(polygone_list, y_values)

areas_polygone=zeros(length(polygone_list),1);
for i=1:length(polygone_list)
    areas_polygone(i) = area(polygone_list{i});
end

new_y_values = [y_values(1)];
area_current = areas_polygone(1);
polygone = polygone_list{1};
for i = 2:length(areas_polygone) % always one less than length(y_values)
    % Neglect, cut, if intersection of both polygons is more than 95%
    if area_current && areas_polygone(i)
        intersection = intersect(polygone,polygone_list{i});
        united_area = union(polygone,polygone_list{i});
        area_intersected = area(intersection);
        area_union = area(united_area);
        ratio = area_intersected/area_union;
    else
        ratio = 0;
    end
    
    if ratio <= 0.97 % area very different, include the cut between these areas
        new_y_values = [new_y_values,y_values(i)];
        % Compare with new polygon and area
        area_current = areas_polygone(i);
        polygone = polygone_list{i};
    end
    % else, don't include the y_value and still compare with the same
    % element
end
new_y_values = [new_y_values,y_values(end)];

end
