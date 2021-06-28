% This script is a test for the functions check_between and
% check_intersection

clc; clear; close all;

radius = 4;
x_circle = 4;
y_circle = 6;

x1 = -1;
x2 = -0.1;
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