clc; clear; close all;

% Any points P (first point == last point):
%P = [0 0; 0 1; 0.5 2; 3 0.5; 2 -3; 0 0];
%P = [0 0; 0.5 0.75; 1 1; 1.5 0.5; 1.5 -0.5; 1.25 0.3; 1 0; 1.25 -0.3; 1 -1; 0 0];
%P = [0 0; 0 1; 1 4; 1.5 2; 2 2.5; 2.2 5; 2.7 3; 3 5; 5 2; 5 0; 3 -2; 2 -1; 1 -2; 0 0];
%P = [0 0; 0 1; 1 1; 1 0; 0 0];
% % problematic shape:
% star_length = 6;
% P = [0 0; 1 star_length; 2 0; star_length+2 -1; 2 -2; 1 -star_length-2; 0 -2; -star_length -1; 0 0];

% % Points k defining a convex polygon:

% % % New definition:
P = [0 0; 0 1; 1 1; 1 0];
P_end = [0 1; 1 1; 1 0; 0 0];
% P = [0 0; 0 1; 1 1; 1 0; 0.25 0.25; 0.75 0.25; 0.75 0.75; 0.25 0.75; 1.5 0; 1.5 1; 2.5 1; 2.5 0];
% P_end = [0 1; 1 1; 1 0; 0 0; 0.75 0.25; 0.75 0.75; 0.25 0.75; 0.25 0.25; 1.5 1; 2.5 1; 2.5 0; 1.5 0];

% P = [0 0; -0.5 0.3; 0.2 0.6; 0 1; 1 1; 1 0; 2 0; 1.5 1; 2.5 1; 2.5 0];
% P_end = [-0.5 0.3; 0.2 0.6; 0 1; 1 1; 1 0; 0 0; 1.5 1; 2.5 1; 2.5 0; 2 0];
% % 
% P = [-1 -1; -1 2; 2 2; 2 -1; 0 0; 0 1; 1 1.5; 1.5 1.8];
% P_end = [-1 2; 2 2; 2 -1; -1 -1; 1.5 1.8; 0 0; 0 1; 1 1.5];


[radii,X,Y,X_red,Y_red,radii_red,max_points,min_points,inner_point,k,points] = approximate_by_circles(P,P_end);

% plot_circles takes as input the output of approximate_by_circles + P +
% P_end
plot_circles(radii,X,Y,X_red,Y_red,radii_red,max_points,min_points,inner_point,k,points,P,P_end)

