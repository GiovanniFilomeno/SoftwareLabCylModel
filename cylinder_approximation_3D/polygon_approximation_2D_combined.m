% Approximate 2D-polygon by circles (red and green)
% Does not work anymore, because of changes to the code
% It was a test for the 3D-code
clc; clear; close all;

%% These are outdated
% Any points P (first point == last point):
%P = [0 0; 0 1; 0.5 2; 3 0.5; 2 -3; 0 0];
%P = [0 0; 0.5 0.75; 1 1; 1.5 0.5; 1.5 -0.5; 1.25 0.3; 1 0; 1.25 -0.3; 1 -1; 0 0];
%P = [0 0; 0 1; 1 4; 1.5 2; 2 2.5; 2.2 5; 2.7 3; 3 5; 5 2; 5 0; 3 -2; 2 -1; 1 -2; 0 0];
%P = [0 0; 0 1; 1 1; 1 0; 0 0];
% % problematic shape:
% star_length = 6;
% P = [0 0; 1 star_length; 2 0; star_length+2 -1; 2 -2; 1 -star_length-2; 0 -2; -star_length -1; 0 0];

%% New definition of polygons
% P: array of all points of polygons
% P_end: defines lines, has the same length as P
% Note:
% polygons need to be defined clockwise
% Holes inside polygons need to be defined counterclockwise
%Simple square
P = [0 0; 0 1; 1 1; 1 0];
P_end = [0 1; 1 1; 1 0; 0 0];
%2 squares, one with square hole
% P = [0 0; 0 1; 1 1; 1 0; 0.25 0.25; 0.75 0.25; 0.75 0.75; 0.25 0.75; 1.5 0; 1.5 1; 2.5 1; 2.5 0];
% P_end = [0 1; 1 1; 1 0; 0 0; 0.75 0.25; 0.75 0.75; 0.25 0.75; 0.25 0.25; 1.5 1; 2.5 1; 2.5 0; 1.5 0];
%2 seperate shapes
% P = [0 0; -0.5 0.3; 0.2 0.6; 0 1; 1 1; 1 0; 2 0; 1.5 1; 2.5 1; 2.5 0];
% P_end = [-0.5 0.3; 0.2 0.6; 0 1; 1 1; 1 0; 0 0; 1.5 1; 2.5 1; 2.5 0; 2 0];
%square with complicated hole
% P = [-1 -1; -1 2; 2 2; 2 -1; 0 0; 0 1; 1 1.5; 1.5 1.8];
% P_end = [-1 2; 2 2; 2 -1; -1 -1; 1.5 1.8; 0 0; 0 1; 1 1.5];

%% Circle approximation

[radii,X,Y,radii_red,X_red,Y_red] = create_circles(P,P_end);

max_points = max(P);
min_points = min(P);
%[radii,X,Y] = remove_circles_proximity(radii,X,Y);
%[radii,X,Y] = remove_circles(radii,X,Y,radii_red,X_red,Y_red,min_points,max_points);

% plot_circles takes as input the output of create_circles + P +
% P_end
% plot_circles(radii,X,Y,radii_red,X_red,Y_red,P,P_end,min_points,max_points)

tic;
for i = 1:40
    compute_area3(X, Y, radii, X_red, Y_red, radii_red);
end
time_a = toc
tic;
for i = 1:40
    compute_area_MC(X, Y, radii, X_red, Y_red, radii_red,[min_points(1),max_points(1)],[min_points(2),max_points(2)]);
end
time_b = toc
% compute_area3(X, Y, radii, X_red, Y_red, radii_red)
% compute_area(X, Y, radii, X_red, Y_red, radii_red,[min_points(1),max_points(1)],[min_points(2),max_points(2)])
