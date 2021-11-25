% Approximate 2D-polygon by circles (red and green)
% Test befor 3D-code worked
% Used to produce illustrations for the presentations
clc; clear; close all;

%% Example polygons
% Any points P (first point == last point):
%P = 
%P = [0 0; 0 1; 1 4; 1.5 2; 2 2.5; 2.2 5; 2.7 3; 3 5; 5 2; 5 0; 3 -2; 2 -1; 1 -2; 0 0];
%P = 

% % star shape:
star_length = 2;
polygon = polyshape([0 0; 1 star_length; 2 0; star_length+2 -1; 2 -2; 1 -star_length-2; 0 -2; -star_length -1]);

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
% polygon = polyshape([0 0; 0 1; 1 4; 1.5 2; 2 2.5; 2.2 5; 2.7 3; 3 5; 5 2; 5 0; 3 -2; 2 -1; 1 -2; 0 0]);

[P,P_end] = convert_polyshape(polygon);

%% Circle approximation
red_radius_factor = 50;
number_circles_per_section = 40;
[radii,X,Z,radii_red,X_red,Z_red] = create_circles(polygon, number_circles_per_section, red_radius_factor);

max_points = max(P);
min_points = min(P);
[radii,X,Z] = remove_circles_proximity(radii,X,Z);
[radii,X,Z] = remove_circles(radii,X,Z,radii_red,X_red,Z_red);

figure();
hold on
[circle_polygon,polygon_red] = create_polyshape(X, Z, radii, X_red, Z_red, radii_red, 600);
plot(circle_polygon,'FaceColor','g','FaceAlpha',1);
area(polygon)
axis equal;

%% Some more plots
[lines_on_hull,inner_point] = find_lines_on_hull(P,P_end);

figure();
hold on
radius = sum(max_points)-sum(min_points);
xlim([inner_point(1)-radius,inner_point(1)+radius])
ylim([inner_point(2)-radius,inner_point(2)+radius])
axis equal
for i = 1:length(radii)
    rectangle('Position',[X(i)-radii(i),Z(i)-radii(i),2*radii(i),2*radii(i)],'Curvature',[1,1], 'FaceColor','g'); % 'EdgeColor','g'
end
plot(polygon_red,'FaceColor','r','FaceAlpha',1);
% The following plot of the red circles is inaccurate, as the radius is so
% large
% for i = 1:length(radii_red)
%     rectangle('Position',[X_red(i)-radii_red(i),Z_red(i)-radii_red(i),2*radii_red(i),2*radii_red(i)],'Curvature',[1,1], 'FaceColor','r'); % 'EdgeColor','g'
% end
for i = 1:length(P)
    plot([P(i,1),P_end(i,1)],[P(i,2),P_end(i,2)],'linewidth',1,'color','blue')
end
hold off

figure();
radius = sum(max_points)-sum(min_points);
xlim([inner_point(1)-radius,inner_point(1)+radius])
ylim([inner_point(2)-radius,inner_point(2)+radius])
axis equal
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

%%
% Plots inside the 3D-plot (copy and run after 3D-code has completed)
% % % y = -30; % For "Combined Shape.stl"
% % % fill3([-40,35,35,-40],[y,y,y,y],[-5,-5,70,70],'k','EdgeColor','k','FaceAlpha',0.3);
% % % 
% % % centers_left = cylinders{1,1};
% % % centers_right = cylinders{1,2};
% % % cylinder_radii = cylinders{1,3};
% % % centers_left_red = cylinders_red{1,1};
% % % centers_right_red = cylinders_red{1,2};
% % % cylinder_radii_red = cylinders_red{1,3};
% % % number_green_cylinders = length(cylinder_radii);
% % % number_red_cylinders = length(cylinder_radii_red);
% % % 
% % % X = zeros(1,number_green_cylinders);
% % % Z = zeros(1,number_green_cylinders);
% % % radii = zeros(1,number_green_cylinders);
% % % for i = 1:number_green_cylinders
% % %     if (y>=centers_left(i,2)) && (y<=centers_right(i,2))
% % %         X(i) = centers_left(i,1);
% % %         Z(i) = centers_left(i,3);
% % %         radii(i) = cylinder_radii(i);
% % %     end
% % % end
% % % X_red = zeros(1,number_red_cylinders);
% % % Z_red = zeros(1,number_red_cylinders);
% % % radii_red = zeros(1,number_red_cylinders);
% % % for i = 1:number_red_cylinders
% % %     if (y>=centers_left_red(i,2)) && (y<=centers_right_red(i,2))
% % %         X_red(i) = centers_left_red(i,1);
% % %         Z_red(i) = centers_left_red(i,3);
% % %         radii_red(i) = cylinder_radii_red(i);
% % %     end
% % % end
% % % [~,index_red] = find(radii_red);
% % % [~,index_green] = find(radii);
% % % figure();
% % % hold on
% % % fill([-100,100,100,-100],[-100,-100,100,100],'k','FaceAlpha',0.3);
% % % area_section = plot_circles(radii(index_green),X(index_green),Z(index_green),radii_red(index_red),X_red(index_red),Z_red(index_red),[]);
% % % axis equal;

%%
% Plots during the run of create_circles, to observe the growth of the
% circles.
figure();
hold on;
for i = 1:length(P)
    plot([P(i,1),P_end(i,1)],[P(i,2),P_end(i,2)],'linewidth',4,'color','blue')
end
for i = 1:length(P)
    if lines_on_hull(i)
        plot([P(i,1),P_end(i,1)],[P(i,2),P_end(i,2)],'--','linewidth',4,'color','red')
    end
end
rectangle('Position',[x_return-radius_return,y_return-radius_return,2*radius_return,2*radius_return],'Curvature',[1,1], 'FaceColor','g'); % 'EdgeColor','g'
axis equal

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
