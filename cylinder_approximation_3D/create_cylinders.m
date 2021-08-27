function [cylinders] = create_cylinders(polygone_list, y_values)

% Cylinders has to be formatted, as needed by other group

y_values = [1,3,4,10];
P1 = [0 0; 0 1.3; 1.3 1.3; 1.3 0];
P_end1 = [P1(2:end,:);P1(1,:)];
P2 = [0 0; 0 1; 1 1; 1 0];
P_end2 = [P2(2:end,:);P2(1,:)];
P3 = [-0.1 0; -0.1 1; 0.9 1; 0.9 0];
P_end3 = [P3(2:end,:);P3(1,:)];
polygone_list = {{P1,P_end1},{P2,P_end2},{P3,P_end3}};

for i=1:length(polygone_list)
    polygone = polygone_list{i};
    P = polygone{1};
    P_end = polygone{2};
    [radii,X,Z,radii_red,X_red,Z_red] = approximate_by_circles(P,P_end);
    max_points = max(P);
    min_points = min(P);
    [radii,X,Z] = remove_circles_proximity(radii,X,Z);
    plot_circles(radii,X,Z,radii_red,X_red,Z_red,P,P_end,min_points,max_points)
end

% Use 2D-algorithm:
% [radii,X,Z,X_red,Z_red,radii_red,max_points,min_points,inner_point,k,points] = approximate_by_circles(P,P_end);

cylinders = [];

end

