clc; clear; close all;

% Any points P (first point == last point):
%%P = [0 0; 0 1; 0.5 2; 3 0.5; 2 -3; 0 0];
%P = [0 0; 0 1; 1 4; 1.5 2; 2 2.5; 2.2 5; 2.7 3; 3 5; 5 2; 5 0; 3 -2; 2 -1; 1 -2; 0 0];
P = [0 0; 0 1; 1 1; 1 0; 0 0];
% % problematic shape:
% star_length = 6;
% P = [0 0; 1 star_length; 2 0; star_length+2 -1; 2 -2; 1 -star_length-2; 0 -2; -star_length -1; 0 0];

% % Points k defining a convex polygon:

points = P; % (k,:);
number_points = length(P);
inner_point = mean(points,1); % always inside the convex polygone

%k = convhull(P);
%points_outer = zeros(number_points);
%points_outer(k) = 1

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
    for pos_loop = linspace(0.05,0.95,7)
        new_circle = 0;
        x_touch = x1+pos_loop*tx;
        y_touch = y1+pos_loop*ty;
        radius = abs_t*8;
        size_step = radius/2;
        for size_loop = 1:20
            if radius > abs_t/32
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

%Note: inaccuracy in plot probably only visual problem (or round-off error)
%For small red circles, it works perfectly