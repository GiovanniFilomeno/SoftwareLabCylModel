clc; clear; close all;

% Any points P (first point == last point):
%P = [0 0; 0.5 0.75; 1 1; 1.5 0.5; 1.5 -0.5; 1.25 0.3; 1 0; 1.25 -0.3; 1 -1; 0 0];
%P = [0 0; 0 1; 0.5 2; 3 0.5; 2 -3; 0 0];
P = [0 0; 0 1; 1 1; 1 0; 0 0];
% Points k defining a convex polygon:
k = convhull(P);
points = P(k,:);
number_points = length(k);
inner_point = mean(points,1); % always inside the polygone

max_points = max(points);
min_points = min(points);
radius = sum(max_points)-sum(min_points);
large_radius = 20*radius;

X = zeros(number_points-1,1);
Y = zeros(number_points-1,1);
radii = ones(number_points-1,1)*large_radius;


figure
hold on

% Define red circles to approximate convex polygone
for i = 1:number_points-1
    x1 = points(i,1);
    y1 = points(i,2);
    x2 = points(i+1,1);
    y2 = points(i+1,2);
    tx = x2-x1;
    ty = y2-y1;
    midx = x1+tx/2;
    midy = y1+ty/2;
    c_square = (tx/2)^2+(ty/2)^2;
    abs_t = sqrt(tx^2+ty^2);
    tx = tx/abs_t;
    ty = ty/abs_t;
    nx1 = -ty;
    ny1 = tx;
    nx2 = ty;
    ny2 = -tx;
    distance_center = sqrt(large_radius^2-c_square);
    cx1 = midx+distance_center*nx1;
    cy1 = midy+distance_center*ny1;
    cx2 = midx+distance_center*nx2;
    cy2 = midy+distance_center*ny2;
    if (inner_point(1)-cx1)^2+(inner_point(2)-cy1)^2 > (inner_point(1)-cx2)^2+(inner_point(2)-cy2)^2
        X(i) = cx1;
        Y(i) = cy1;
    else
        X(i) = cx2;
        Y(i) = cy2;
    end
end


xlim([inner_point(1)-radius,inner_point(1)+radius])
ylim([inner_point(2)-radius,inner_point(2)+radius])
axis square
% viscircles([X, Y],radii,'Color','r')
% viscircles([inner_point(1), inner_point(2)],radius,'Color','g')
% scatter(inner_point(1),inner_point(2))
% plot(points(:,1),points(:,2),'linewidth',1,'color','blue')
rectangle('Position',[inner_point(1)-radius,inner_point(2)-radius,2*radius,2*radius],'Curvature',[1,1], 'FaceColor','g'); % 'EdgeColor','g'
for i = 1:number_points-1
    rectangle('Position',[X(i)-radii(i),Y(i)-radii(i),2*radii(i),2*radii(i)],'Curvature',[1,1], 'FaceColor','r'); % 'EdgeColor','g'
end
hold off

%Note: inaccuracy in plot probably only visual problem (or round-off error)
%For small red circles, it works perfectly