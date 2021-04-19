clc; clear; close all;

%%
% Test of some ideas for simple model problem:
% Approximate the square [-1,1]x[-1,1] by circles.
%
% Similar to what Giovanni explained: green and red circles available
% The obtained geometry is defined as:
%   Union of red circles substracted from union of green circles
%   Check if point is inside the geometry:
%       It is inside, if it is in all green but in no red circles.
%
% To do the approximation, I tried to do some optimizations
% The optimization algorithms failed, but parts could be reused for other
% tests
%%
% Content:
% - Test, if point is inside the constructed circle geometry
%   (function test_inside)
% - Plot the situation
%   (function plot_image)
% - Check, if the geometry is inside the square
%   That test is done by checking many points at the boundary
%   (function boundary_check)
% - Compute the distance of the geometry to the boundary
%   This is done by random samples and the minimum distance is kept
%   (function boundary_distance)
% - Compute the area of the geometry
%	This is done by random samples in the square and counting the points 
%   inside the geometry to get the fraction of the area of the square
%   (function compute_area)
%%
% Summary:
% - Optimization (Of a square, using red+green circles):
%   Maximize area (minimize negative area)
%   Constraint is, that distance to the boundary is greater than 0
% - Currently, the functions for area and distance computation contain
%	random noise (only computed by random sampling)
%   That is the reason, why the optimization algorithm fmincon doesn't work
% - I tried to optimize it by trying many random configurations of the
%	circles
%   That method is far too slow
%
% Ideas for it to work:
% - Define analytical function for area and distance (complicated)
%   see this forum (not even red circles taken into account):
%   https://de.mathworks.com/matlabcentral/answers/363603-derivative-free-optimisation-with-over-100-variables
% - Compute area and distance by approximating cylinders with polygones
%   Still difficult and may introduce discontinuities
%   Maybe still not possible for standart optimization algorithm
% - Use a more sophisticated optimization algorithm based on random samples
%   see this forum
%   https://stackoverflow.com/questions/1667310/combined-area-of-overlapping-circles
%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Skip the following section, it's just tests and unstructured ideas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% mesh = stlread('simple_cube.stl');
% mesh.faces

% Compute Volume/Area
%
% For all green cylinders:
% Area covered by all circles
% + Area of each circle
% - Area of intersections
% + Area of 3xintersections
% 
% Including red cylinders:
% - Area red and green
% + Area red and 2xgreen
% + Area 2xred and green
%
% Each area computation difficult!!!


% Check if inside boundary
%
% Does any green cylinder intersect with any triangle?
% Store these cylinders and triangles
% Compute intersected green area
% Compute intersection between these triangles and red cylinders
% Compute intersected red area
% Check, if green area included in red area
%
% Many difficult steps included!!!!

% Idea: Sample stl-file uniformly with many points inside and outside of stl
% Instead of area count points inside csg
% Boundary: Check, that no outer points part of csg

% NEW idea:
% Area: Sample region and do monte-carlo-algorithm
% Boundary: Sample Boundary uniformly and check, if all points outside
% cylinders

n_green = 1;
n_red = 4;

% Stores first green, then red circles
% x,y,radius
%variable = ones(1,n_green*3+n_red*3);
%variable = [0,0,2, -2.8,0,2.2, 2.8,0,2.2, 0,-2.8,2.2, 0,2.8,2.2];
%plot_image(variable,n_green,n_red)
%boundary_distance(variable, n_green, n_red)
%boundary_distance(variable, n_green, n_red)
%boundary_distance(variable, n_green, n_red)

% Successful test of plot_image
%variable = [-1.08,0.58,4.69, -6.11,0.92,0.10, 7.62,0.68,0.10, 2.05,-4.94,1.31, 0.00,2.96,2.00];
%compute_area(variable, n_green, n_red);
%plot_image(variable,n_green,n_red)
%boundary_check(variable, n_green, n_red)

% Successful test of is_inside
% variable = [0,0,2, -4,0,2, 3,0,2, 0,-4,2, 0,4,2];
% test_inside(variable,0,0,n_green,n_red)
% test_inside(variable,0,1,n_green,n_red)
% test_inside(variable,0,-3,n_green,n_red)
% test_inside(variable,0,2.5,n_green,n_red)
% test_inside(variable,4,4,n_green,n_red)
% variable = [0,0,3, -8.5,0,8, 8.5,0,8, 0,-8.5,8, 0,8.5,8];
% test_inside(variable,1,1,n_green,n_red)
% test_inside(variable,0,1,n_green,n_red)

% test of boundary_check and area
% boundary_check(variable, n_green, n_red)
% compute_area(variable, n_green, n_red)
% variable = [0,0,1.5, -2.7,0,2, 2.7,0,2, 0,-2.7,2, 0,2.7,2];
% plot_image(variable,n_green,n_red)
variable = [0,0,1.5, -sqrt(440),0,20, sqrt(440),0,20, 0,-sqrt(440),20, 0,sqrt(440),20];
plot_image(variable,n_green,n_red)
compute_area(variable, n_green, n_red)
compute_area(variable, n_green, n_red)
compute_area(variable, n_green, n_red)
% variable = [0,0,1.5, -sqrt(1680),0,40, sqrt(1680),0,40, 0,-sqrt(1680),40, 0,sqrt(1680),40];
% plot_image(variable,n_green,n_red)
% compute_area(variable, n_green, n_red)
% boundary_check(variable, n_green, n_red)
% compute_area(variable, n_green, n_red)
% variable = [0,0,3, -8.5,0,8, 8.5,0,8, 0,-8.5,8, 0,8.5,8];
% plot_image(variable,n_green,n_red)
% boundary_check(variable, n_green, n_red)
% compute_area(variable, n_green, n_red)
% variable = [0,0,3, -8.5,0,8, 8.5,0,8, 0,-8.5,8, 0,6,8];
% plot_image(variable,n_green,n_red)
% boundary_check(variable, n_green, n_red)
% compute_area(variable, n_green, n_red)

% Check for uncertainty in compute area
%compute_area(variable, n_green, n_red)
%compute_area(variable, n_green, n_red)
%compute_area(variable, n_green, n_red)

% Test of optimization function
% sample_multiplier = 4;
% n_green = 5;
% n_red = 0;
% variable = [0,0,0.7, 0,0,0.7, 0,0,0.7, 0,0,0.7, 0,0,0.7];
% compute_area(variable, n_green, n_red)
% plot_image(variable,n_green,n_red)
% test_variable = zeros(50,(n_green+n_red)*3);
% variable_largest5 = zeros(5,(n_green+n_red)*3);
% areas = zeros(1,50);
% for j=1:200
%     for i = 0:n_green+n_red-1
%         test_variable(j,3*i+1) = normrnd(0,0.4);
%         test_variable(j,3*i+2) = normrnd(0,0.4);
%         new_radius = normrnd(0.7,0.4);
%         if new_radius < 0
%             new_radius = 0;
%         end
%         test_variable(j,3*i+3) = new_radius;
%     end
%     if boundary_check(test_variable(j,:), n_green, n_red)
%         areas(j) = compute_area(test_variable(j,:), n_green, n_red);
%     end
% end
% [largest5,indices] = maxk(areas,5);
% variable_largest5 = test_variable(indices,:);
% 
% for iterations = 1:4
%     var = 0.1;
%     for k = 0:4
%         for j = 1:39
%             for i = 0:n_green+n_red-1
%                 test_variable(39*k+j,3*i+1) = normrnd(variable_largest5(k+1,3*i+1),var);
%                 test_variable(39*k+j,3*i+2) = normrnd(variable_largest5(k+1,3*i+2),var);
%                 new_radius = normrnd(variable_largest5(k+1,3*i+3),var);
%                 if new_radius < 0
%                     new_radius = 0;
%                 end
%                 test_variable(39*k+j,3*i+3) = new_radius;
%             end
%             if boundary_check(test_variable(39*k+j,:), n_green, n_red)
%                 areas(39*k+j) = compute_area(test_variable(39*k+j,:), n_green, n_red);
%             end
%         end
%     end
%     test_variable(196:200,:) = variable_largest5;
%     areas(196:200) = largest5;
%     [largest5,indices] = maxk(areas,5);
%     variable_largest5 = test_variable(indices,:);
% end
% plot_image(test_variable(indices(1),:),n_green,n_red)

% Needs continuous function!!!
% f = @(variable_vector) -compute_area(variable_vector, n_green, n_red);
% constraint_fun = @(variable_vector) constraint(variable_vector, n_green, n_red);
% x0=variable; A=[]; B=[]; Aeq=[]; Beq=[];
% %xm=[-10,-10,0.1, -1000,-1000,0.1, -1000,-1000,0.1, -1000,-1000,0.1, -1000,-1000,0.1]; % lower bound
% %xM=[10,10,15, 1000,1000,1500, 1000,1000,1500, 1000,1000,1500, 1000,1000,1500]; % upper bound
% xm = [-1,-1,0.1, -1,-1,0.1, -1,-1,0.1, -1,-1,0.1, -1,-1,0.1];
% xM = [1,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1];
% options = optimoptions(@fmincon,'Algorithm','interior-point','OptimalityTolerance',1.0e-2); %'interior-point','active-set'
% [x, f0, flag, d] = fmincon(f,x0,A,B,Aeq,Beq,xm,xM,constraint_fun,options);
% plot_image(x,n_green,n_red)


% function [c,ce]=constraint(variable_vector, n_green, n_red)
% ce = [];
% %c = -2*boundary_check(variable_vector, n_green, n_red)+1;
% c = -boundary_distance(variable_vector, n_green, n_red);
% end

%%
% This is an optimization example from the book
% "Solving Optimization Problems with Matlab" (pp.163 Example 5.7)
%
% f=@(x) -(cos((x(1)-0.1)*x(2)))^2-x(1)*sin(3*x(1)+x(2));
% x0=[-10; -10]; A=[]; B=[]; Aeq=[]; Beq=[]; xm=[]; xM=[];
% [x, f0, flag, d] = fmincon(f,x0,A,B,Aeq,Beq,xm,xM,@c5mtown);
% function [c,ce]=c5mtown(x)
% ce=[]; t=atan2(x(1),x(2));
% c=x(1)^2+x(2)^2-4*sin(t)^2-(2*cos(t)-cos(2*t)/2-cos(3*t)/4-cos(4*t)/8)^2;
% end

%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start of working functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%
% Tests, if a given point lies inside a cylinder-structure
function is_inside = test_inside(variable_vector,x,y,n_green,n_red)
is_inside = false;
for ig = 0:n_green-1
    x_dist = variable_vector(ig*3+1)-x;
    y_dist = variable_vector(ig*3+2)-y;
    radius = variable_vector(ig*3+3);
    if x_dist^2+y_dist^2 < radius^2
        is_inside = true;
    end
end
for ir = 0:n_red-1
    x_dist = variable_vector(n_green*3+ir*3+1)-x;
    y_dist = variable_vector(n_green*3+ir*3+2)-y;
    radius = variable_vector(n_green*3+ir*3+3);
    if x_dist^2+y_dist^2 < radius^2
        is_inside = false;
    end
end
end

%%
% Plots cylinder-structure
function plot_image(variable_vector,n_green,n_red)
figure();
hold on
for ig = 0:n_green-1
    x_circ = variable_vector(ig*3+1);
    y_circ = variable_vector(ig*3+2);
    radius = variable_vector(ig*3+3);
    viscircles([x_circ,y_circ],radius,'Color','green');
end
for ir = 0:n_red-1
    x_circ = variable_vector(n_green*3+ir*3+1);
    y_circ = variable_vector(n_green*3+ir*3+2);
    radius = variable_vector(n_green*3+ir*3+3);
    viscircles([x_circ,y_circ],radius,'Color','red');
end
rectangle('Position',[-1,-1,2,2])
hold off
daspect([1 1 1])
end

%%
% Check boundary for box [-1,1]x[-1,1]
% Check, if some controlpoints are not inside the cylinder-structure
% That means, the structure is inside the allowed space
% Returns true/1, if boundary is ok
function is_ok = boundary_check(variable_vector, n_green, n_red)
is_ok = true;
values = linspace(-1,1,10000);
for i = 1:10000
    left = test_inside(variable_vector,-1,values(i),n_green,n_red);
    right = test_inside(variable_vector,1,values(i),n_green,n_red);
    bottom = test_inside(variable_vector,values(i),-1,n_green,n_red);
    top = test_inside(variable_vector,values(i),1,n_green,n_red);
    if (left||right||bottom||top)
        is_ok = false;
        break
    end

end
end

%%
%Compute distance by sampling
function dist = boundary_distance(variable_vector, n_green, n_red)
dist = 1;
%tests_x = zeros(1,10000);
%tests_y = zeros(1,10000);
for i = 1:1000000
    %test_x = 2*rand()-1;
    %test_y = 2*rand()-1;
    test_x = 2.4*rand()-1.2;
    test_y = 2.4*rand()-1.2;
    
    % Change intervalls from
    % [-1,0] and [0,1]
    % to [-1.2,-1+dist] and [1-dist,1.2]
    %if test_x < 0
    %    test_x = -1.2-dist*test_x;
    %else
    %    test_x = 1-dist+dist*test_x;
    %end
    %if test_y < 0
    %    test_y = -1.2-dist*test_y;
    %else
    %    test_y = 1-dist+dist*test_y;
    %end
    %tests_x(i) = test_x;
    %tests_y(i) = test_y;
    
    if test_inside(variable_vector, test_x, test_y, n_green, n_red)
        current_dist = min([1-test_x,test_x+1,1-test_y,test_y+1]);
        if current_dist < dist
            dist = current_dist;
        end
    end
end
%plot(tests_x)
%plot(tests_y)
end

%%
function area = compute_area(variable_vector, n_green, n_red)
x_tests = -1+2*rand(1,1000000);
y_tests = -1+2*rand(1,1000000);
results = zeros(1,1000000);
for i = 1:1000000
    results(i) = test_inside(variable_vector,x_tests(i),y_tests(i),n_green,n_red);
end
area = 4*mean(results);
end