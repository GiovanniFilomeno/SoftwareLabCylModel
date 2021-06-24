clc; clear; close all;

radius = 4;
x_circle = 4;
y_circle = 6;

x1 = 0;
x2 = 2;
y1 = 6;
y2 = 6;

distance = distance_point_line([x1,y1],[x2,y2],[x_circle,y_circle]);
intersect = check_intersection([x1,y1],[x2,y2],[x_circle,y_circle],radius);

figure();
axis equal;
hold on
viscircles([x_circle,y_circle],radius,'Color','r');
plot([x1,x2],[y1,y2]);
hold off

function distance = distance_point_line(end1,end2,point)
x1 = end1(1);
y1 = end1(2);
x2 = end2(1);
y2 = end2(2);
x = point(1);
y = point(2);
tx = x2-x1; % Line vector
ty = y2-y1;
abs_t = sqrt(tx^2+ty^2);
tx = tx/abs_t; % Normalized Line Vector
ty = ty/abs_t;
nx = -ty; % Normal vector
ny = tx;
distance = nx*x+ny*y;
end

function intersect = check_intersection(end1,end2,center,radius)
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
distance = nx*(x-x1)+ny*(y-y1); % distance line center
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

% Assume point on line, check, if point is between points 1 and 2
function is_between = check_between(point1,point2,point)
t1x = point(1)-point1(1); % normal from point to points 1 and 2
t1y = point(2)-point1(2);
t2x = point(1)-point2(1);
t2y = point(2)-point2(2);
is_between = 1;
if t1x*t2x+t1y*t2y > 0 % if normals have same sign, point not between
    is_between = 0;
end
end