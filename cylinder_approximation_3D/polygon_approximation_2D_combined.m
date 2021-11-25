% Approximate 2D-polygon by circles (red and green)
% Does not work anymore, because of changes to the code
% It was a test for the 2D-code, that is also used in the 3D-code
clc; clear; close all;

%% Example polygons
% Any points P (first point == last point):
%P = 
%P = [0 0; 0 1; 1 4; 1.5 2; 2 2.5; 2.2 5; 2.7 3; 3 5; 5 2; 5 0; 3 -2; 2 -1; 1 -2; 0 0];
%P = 

% % star shape:
% star_length = 6;
% polygon = polyshape([0 0; 1 star_length; 2 0; star_length+2 -1; 2 -2; 1 -star_length-2; 0 -2; -star_length -1]);

% %2 squares, one with square hole
% polygon = polyshape([0 0; 0 1; 1 1; 1 0]);
% polygon = addboundary(polygon,[0.25 0.25; 0.75 0.25; 0.75 0.75; 0.25 0.75]);
% polygon = addboundary(polygon,[1.5 0; 1.5 1; 2.5 1; 2.5 0]);

% % 2 seperate shapes
% polygon = polyshape([0 0; -0.5 0.3; 0.2 0.6; 0 1; 1 1; 1 0]);
% polygon = addboundary(polygon,[ 2 0; 1.5 1; 2.5 1; 2.5 0]);

% % square with complicated hole
% polygon = polyshape([-1 -1; -1 2; 2 2; 2 -1]);
% polygon = addboundary(polygon,[0 0; 0 1; 1 1.5; 1.5 1.8]);

% % single region polygons
% polygon = polyshape([0 0; 0 1; 1 1; 1 0]);
% polygon = polyshape([0 0; 0 1; 0.5 2; 3 0.5; 2 -3; 0 0]);
% polygon = polyshape([0 0; 0.5 0.75; 1 1; 1.5 0.5; 1.5 -0.5; 1.25 0.3; 1 0; 1.25 -0.3; 1 -1; 0 0]);
polygon = polyshape([0 0; 0 1; 1 4; 1.5 2; 2 2.5; 2.2 5; 2.7 3; 3 5; 5 2; 5 0; 3 -2; 2 -1; 1 -2; 0 0]);

[P,P_end] = convert_polyshape(polygon);

%% Circle approximation
red_radius_factor = 50;
number_circles_per_section = 80;
[radii,X,Y,radii_red,X_red,Y_red] = create_circles(polygon, number_circles_per_section, red_radius_factor);

max_points = max(P);
min_points = min(P);
[radii,X,Y] = remove_circles_proximity(radii,X,Y);
% [radii,X,Y] = remove_circles(radii,X,Y,radii_red,X_red,Y_red);

figure();
plot_circles(radii,X,Y,radii_red,X_red,Y_red,[])
area(polygon)
axis equal;

%% Some more plots
[lines_on_hull,inner_point] = find_lines_on_hull(P,P_end);

% figure();
% hold on
% radius = sum(max_points)-sum(min_points);
% xlim([inner_point(1)-radius,inner_point(1)+radius])
% ylim([inner_point(2)-radius,inner_point(2)+radius])
% axis square
% for i = 1:length(radii)
%     rectangle('Position',[X(i)-radii(i),Y(i)-radii(i),2*radii(i),2*radii(i)],'Curvature',[1,1], 'FaceColor','g'); % 'EdgeColor','g'
% end
% for i = 1:length(radii_red)
%     rectangle('Position',[X_red(i)-radii_red(i),Y_red(i)-radii_red(i),2*radii_red(i),2*radii_red(i)],'Curvature',[1,1], 'FaceColor','r'); % 'EdgeColor','g'
% end
% for i = 1:length(P)
%     plot([P(i,1),P_end(i,1)],[P(i,2),P_end(i,2)],'linewidth',1,'color','blue')
% end
% hold off

figure();
radius = sum(max_points)-sum(min_points);
xlim([inner_point(1)-radius,inner_point(1)+radius])
ylim([inner_point(2)-radius,inner_point(2)+radius])
axis square
hold on
for i = 1:length(P)
    plot([P(i,1),P_end(i,1)],[P(i,2),P_end(i,2)],'linewidth',4,'color','blue')
end
for i = 1:length(P)
    if lines_on_hull(i)
        plot([P(i,1),P_end(i,1)],[P(i,2),P_end(i,2)],'--','linewidth',4,'color','red')
    end
end
k = convhull(P);
plot(P(k,1),P(k,2),'--','linewidth',1,'color','red');
hold off

%% Test, which compute_area function is faster
% compute_area3 is faster when computed sequentially, but compute_areaMC is
% faster when computed parallel. However, compute_area3 is more accurate
% and has no random fluctuations, so it is used for this project.
% tic;
% for i = 1:40
%     compute_area3(X, Y, radii, X_red, Y_red, radii_red);
% end
% time_a = toc
% tic;
% for i = 1:40
%     compute_area_MC(X, Y, radii, X_red, Y_red, radii_red,[min_points(1),max_points(1)],[min_points(2),max_points(2)]);
% end
% time_b = toc
