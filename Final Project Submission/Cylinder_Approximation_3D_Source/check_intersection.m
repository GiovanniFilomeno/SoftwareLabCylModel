function intersect = check_intersection(end1,end2,center,radius)
% 
% check_intersection determines, wether a line defined by the points end1 and end2
% overlaps with a circle defined by the center point and the radius
%
%Inputs:
%         :end1,end2: defines the line
%         :center,radius: defines the circle
%Outputs:
%         :intersect: boolean value, if there is an intersection

x1 = end1(1);
y1 = end1(2);
x2 = end2(1);
y2 = end2(2);
x = center(1);
y = center(2);
tx = x2-x1; % Line vector
ty = y2-y1;
abs_t = sqrt(tx^2+ty^2);
tx = tx/abs_t; % Normalized Line Vector
ty = ty/abs_t;
nx = -ty; % Normal vector
ny = tx;
distance = nx*(x-x1)+ny*(y-y1); % distance between line and center
if radius <= abs(distance)
    intersect = 0;
else
    x_closest = x-distance*nx; % point on line closest to center
    y_closest = y-distance*ny;
    s = sqrt(radius^2-distance^2); % distance from closest point to intersection point
    intersect1x = x_closest+tx*s; % intersection points
    intersect1y = y_closest+ty*s;
    intersect2x = x_closest-tx*s;
    intersect2y = y_closest-ty*s;
    intersect = 0;
    if (check_between([x1,y1],[x2,y2],[intersect1x,intersect1y])) || (check_between([x1,y1],[x2,y2],[intersect2x,intersect2y]))
        intersect = 1;
    end
    if (x1-x)^2+(y1-y)^2<radius^2 || (x2-x)^2+(y2-y)^2<radius^2
        intersect = 1;
    end
end
end