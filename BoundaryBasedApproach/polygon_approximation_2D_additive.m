clc; clear; close all;

% profile on;

% Any points P (first point == last point):
%P = [0 0; 0.5 0.75; 1 1; 1.5 0.5; 1.5 -0.5; 1.25 0.3; 1 0; 1.25 -0.3; 1 -1; 0 0];
%P = [0 0; 0 1; 0.5 2; 3 0.5; 2 -3; 0 0];
%P = [0 0; 0 1; 1 4; 1.5 2; 2 2.5; 2.2 5; 2.7 3; 3 5; 5 2; 5 0; 3 -2; 2 -1; 1 -2; 0 0];
P = [0 0; 0 1; 1 1; 1 0; 0 0];

% % problematic shape:
% star_length = 3;
% P = [0 0; 1 star_length; 2 0; star_length+2 -1; 2 -2; 1 -star_length-2; 0 -2; -star_length -1; 0 0];

% % Points k defining a convex polygon:
% k = convhull(P);
points = P; % (k,:);
number_points = length(P);
inner_point = mean(points,1); % always inside the convex polygone

max_points = max(points);
min_points = min(points);
radius = sum(max_points)-sum(min_points);
large_radius = 10*radius;

X = zeros(number_points*5,1);
Y = zeros(number_points*5,1);
radii = zeros(number_points*5,1);

figure()
hold on

number_circles = 1;
% Define green circles to approximate polygone
for line_loop = 1:number_points-1 % as last point=first point
    x1 = P(line_loop,1);
    y1 = P(line_loop,2);
    x2 = P(line_loop+1,1);
    y2 = P(line_loop+1,2);
    tx = x2-x1; % Line vector
    ty = y2-y1;
    abs_t = sqrt(tx^2+ty^2);
    tx_normal = tx/abs_t; % Normalized Line Vector
    ty_normal = ty/abs_t;
    % Normal vectors need to point inside, they do, if points are clockwise
    nx = ty_normal; % Normal vector
    ny = -tx_normal;
    for pos_loop = linspace(0.05,0.95,9)
        new_circle = 0;
        x_touch = x1+pos_loop*tx;
        y_touch = y1+pos_loop*ty;
        radius = abs_t*8;
        size_step = radius/2;
        for size_loop = 1:20
            if radius > abs_t/128
                x_center = x_touch+nx*radius;
                y_center = y_touch+ny*radius;
                radius_ok = 1;
                for i = 1:number_points-1
                    if i ~= line_loop
                        x_test1 = P(i,1);
                        y_test1 = P(i,2);
                        x_test2 = P(i+1,1);
                        y_test2 = P(i+1,2);
                        if check_intersection([x_test1,y_test1],[x_test2,y_test2],[x_center,y_center],radius)
                            radius_ok = 0;
                        end
                    end
                end
                if radius_ok
                    X(number_circles) = x_center;
                    Y(number_circles) = y_center;
                    radii(number_circles) = radius;
                    radius = radius+size_step;
                    new_circle = 1;
                else
                    radius = radius-size_step;
                end
            else
                break;
            end
            size_step = size_step/2;
        end
        if new_circle
            number_circles = number_circles+1;
        end
    end
end

number_circles = number_circles-1;
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

% % Define red circles to approximate convex polygone
% for i = 1:number_points-1 % as last point=first point
%     x1 = points(i,1);
%     y1 = points(i,2);
%     x2 = points(i+1,1);
%     y2 = points(i+1,2);
%     tx = x2-x1;
%     ty = y2-y1;
%     midx = x1+tx/2;
%     midy = y1+ty/2;
%     c_square = (tx/2)^2+(ty/2)^2;
%     abs_t = sqrt(tx^2+ty^2);
%     tx = tx/abs_t;
%     ty = ty/abs_t;
%     nx1 = -ty;
%     ny1 = tx;
%     nx2 = ty;
%     ny2 = -tx;
%     distance_center = sqrt(large_radius^2-c_square);
%     cx1 = midx+distance_center*nx1;
%     cy1 = midy+distance_center*ny1;
%     cx2 = midx+distance_center*nx2;
%     cy2 = midy+distance_center*ny2;
%     if (inner_point(1)-cx1)^2+(inner_point(2)-cy1)^2 > (inner_point(1)-cx2)^2+(inner_point(2)-cy2)^2
%         X(i) = cx1;
%         Y(i) = cy1;
%     else
%         X(i) = cx2;
%         Y(i) = cy2;
%     end
% end


compute_area(X,Y,radii,number_circles-1,0,[min_points(1),max_points(1)],[min_points(2),max_points(2)])

compute_area(X,Y,radii,number_circles-1,0,[min_points(1),max_points(1)],[min_points(2),max_points(2)])

radius = sum(max_points)-sum(min_points);
xlim([inner_point(1)-radius,inner_point(1)+radius])
ylim([inner_point(2)-radius,inner_point(2)+radius])
axis square
for i = 1:number_circles-1
    rectangle('Position',[X(i)-radii(i),Y(i)-radii(i),2*radii(i),2*radii(i)],'Curvature',[1,1], 'FaceColor','g'); % 'EdgeColor','g'
end
% viscircles([X, Y],radii,'Color','r');
% viscircles([inner_point(1), inner_point(2)],radius,'Color','g')
% scatter(inner_point(1),inner_point(2))
plot(points(:,1),points(:,2),'linewidth',1,'color','blue')
hold off

% profile off;
% profile viewer;

%Note: inaccuracy in plot probably only visual problem (or round-off error)
%For small red circles, it works perfectly

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

% Computes the area by computing the fraction of the area inside the
% bounding box
function area = compute_area(X, Y, radii, n_green, n_red, bounds_x, bounds_y)
number = 100000;
length_x = bounds_x(2)-bounds_x(1);
length_y = bounds_y(2)-bounds_y(1);
x_tests = bounds_x(1)+length_x*rand(1,number);
y_tests = bounds_y(1)+length_y*rand(1,number);
results = zeros(1,number);
for i = 1:number
    results(i) = test_inside(X,Y,radii,x_tests(i),y_tests(i),n_green,n_red);
end
area = length_x*length_y*mean(results);
end

% Tests, if a given point lies inside a cylinder-structure
function is_inside = test_inside(X,Y,radii,x,y,n_green,n_red)
is_inside = false;
x_dist = X(1:n_green)-x;
y_dist = Y(1:n_green)-y;
radius = radii(1:n_green);
condition = x_dist.^2+y_dist.^2<radius.^2;
if sum(condition) > 0
    is_inside = true;
end
%This second part not yet tested
x_dist = X(n_green+1:end)-x;
y_dist = Y(n_green+1:end)-y;
radius = radii(n_green+1:end);
condition = x_dist.^2+y_dist.^2<radius.^2;
if sum(condition) > 0
    is_inside = false;
end
end