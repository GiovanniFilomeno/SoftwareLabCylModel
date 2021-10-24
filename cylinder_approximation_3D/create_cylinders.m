% This function uses the 2D-algorithm (approximation of 2D-polygones with
% circles) in order to approximate each section of the geometry with
% cylinders. If possible, it reuses cylinders from previous sections (from
% left to right)
function [cylinders,cylinders_red] = create_cylinders(polygone_list, y_values)

% Test input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Cylinders has to be formatted, as needed by other group
% y_values = [1,3,4,10];
% P1 = [0 0; 0.5 0.75; 1 1; 1.5 0.5; 1.5 -0.5; 1.25 0.3; 1 0; 1.25 -0.3; 1 -1];
% %P1 = [0 0; 0 1.3; 1.3 1.3; 1.3 0];
% P_end1 = [P1(2:end,:);P1(1,:)];
% P2 = [0 0; 0 1; 1 1; 1 0];
% P_end2 = [P2(2:end,:);P2(1,:)];
% P3 = [-0.1 0; -0.1 1; 0.4 0.7; 0.9 1; 0.9 0];
% P_end3 = [P3(2:end,:);P3(1,:)];
% polygone_list = {{P1,P_end1},{P2,P_end2},{P3,P_end3}};
% %polygone_list = {{P1,P_end1},{P1,P_end1},{P1,P_end1}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

centers_left = [];

centers_right = [];
cylinder_radii = [];
centers_left_red = [];
centers_right_red = [];
cylinder_radii_red = [];
radii_stay = []; % Circles, which are used in the next level
X_stay = [];
Z_stay = [];
indices_stay = []; % Indices of the corresponding cylinders
radii = []; % Circles in the last section
X = [];
Z = [];
indices_last = []; % Indices of the corresponding cylinders
for i=1:length(polygone_list)
    polygon = polygone_list{i};
%     P = polygone{1};
%     P_end = polygone{2};
    [P, P_end] = convert_polyshape(polygon);
    if isempty(P)
        continue
    end
    [lines_on_hull,~] = find_lines_on_hull(P,P_end);
    %%
    % Check, which cylinders from last layer can be used in the next one
    % for free. For these circles, which are marked with _stay, the
    % index of the corresponding cylinder has to be saved. Then, the length
    % of the cylinder can be increased.
    % For that, all circles of the previous section (and indices) are
    % collected (including ones from pre-pre-sections, etc.). Then, it is
    % checked, if these circles fit into the current polygone. If yes, the
    % corresponding cylinder is elongated.
    radii_stay_new = [];
    X_stay_new = [];
    Z_stay_new = [];
    indices_stay_new = [];
   
    radii = [radii;radii_stay]; % final set of cylinders of previous section
    X = [X;X_stay];
    Z = [Z;Z_stay];
    indices_stay = [indices_last;indices_stay];
    n = length(radii);
    for j = 1:n % Loop over previous cylinders
        circle_fits = 1;
        for k = 1:length(P)
            if lines_on_hull(k)==0
                x_test1 = P(k,1);
                z_test1 = P(k,2);
                x_test2 = P_end(k,1);
                z_test2 = P_end(k,2);
                if check_intersection([x_test1,z_test1],[x_test2,z_test2],[X(j),Z(j)],radii(j))
                    circle_fits = 0;
                end
            end
            if ~isinterior(polygon,X(j),Z(j))
                circle_fits = 0;
            end
        end
        if circle_fits % Reuse circle and change length of cylinder
            radii_stay_new = [radii_stay_new;radii(j)];
            X_stay_new = [X_stay_new;X(j)];
            Z_stay_new = [Z_stay_new;Z(j)];
            indices_stay_new = [indices_stay_new;indices_stay(j)];
            centers_right(indices_stay(j),2) = y_values(i+1); % Updated length
        end
    end
    radii_stay = radii_stay_new; % reused cylinders of previous section
    X_stay = X_stay_new;
    Z_stay = Z_stay_new;
    indices_stay = indices_stay_new;
    %%
    % Use 2D-code
    [radii,X,Z,radii_red,X_red,Z_red] = approximate_by_circles(polygon);
    max_points = max(P);
    min_points = min(P);
    [radii,X,Z] = remove_circles_proximity(radii,X,Z,radii_stay,X_stay,Z_stay);
    [radii,X,Z] = remove_circles(radii,X,Z,radii_red,X_red,Z_red,min_points,max_points,radii_stay,X_stay,Z_stay);
    %plot_circles([radii;radii_stay],[X;X_stay],[Z;Z_stay],radii_red,X_red,Z_red,y_values(i))
%     plot_circles(radii_stay,X_stay,Z_stay,radii_red,X_red,Z_red,y_values(i))
    
    % Define cylinders:
    indices_last = [length(cylinder_radii)+1:length(cylinder_radii)+length(radii)]';
    cylinder_radii = [cylinder_radii;radii];
    centers_left = [centers_left;[X,ones(length(radii),1).*y_values(i),Z]];
    centers_right = [centers_right;[X,ones(length(radii),1).*y_values(i+1),Z]];
    centers_left_red = [centers_left_red;[X_red,ones(length(radii_red),1).*y_values(i),Z_red]];
    centers_right_red = [centers_right_red;[X_red,ones(length(radii_red),1).*y_values(i+1),Z_red]];
    cylinder_radii_red = [cylinder_radii_red;radii_red];
    disp("Number of new green circles in section: "+string(length(radii)))
end

cylinders = {centers_left,centers_right,cylinder_radii};
cylinders_red = {centers_left_red,centers_right_red,cylinder_radii_red};

end

