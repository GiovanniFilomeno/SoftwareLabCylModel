function [cylinders,cylinders_red] = create_cylinders(polygon_list, y_values, number_circles_per_section, red_radius_factor, remove_circle_parameters)
% 
% create_cylinders approximates a geometry by cylinders. The original
% geometry is not given, instead, it is divided into several sections
% between certain y-values. Between any 2 of these y-values, the geometry
% is defined by 2D-polygons. If all 2D-polygons are extruded between the 2
% corresponding y-values, that gives the geometry. So at the end, that
% geometry is approximated by cylinders.
% This function uses the 2D-algorithm (approximation of all 2D-polygons with
% circles) in order to approximate each section of the geometry with
% cylinders. If possible, it reuses cylinders from previous sections (from
% left to right)
% In the resulting approximation, one set of cylinders is added and another
% set is subtracted, in order to form the geometry.
%
%Inputs:
%         :polygon_list: list of 2D-polygons, which fit into a certain
%                         geometry that should be approximated
%         :y_values: array of length polygon_list + 1, stores all y_values
%                    between which the 2D-polygons span the original geometry
%                    
%         :number_circles_per_section,red_radius_factor: Used in the
%                                                        2D-code, which approximates polygons by circles. (See
%                                                        create_circles)
%         :remove_circle_parameters: Used for the functions
%                                    remove_circles_proximity and remove_circles
%Outputs:
%         :cylinders: list of all cylinders, which are added to the geometry.
%                     It consists of the coordinates for both endpoints of the cylinders 
%                     and the radius
%         :cylinders_red: list of all cylinders, which are subtracted from
%                         the geometry. Same structure, as cylinders

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
% polygon_list = {{P1,P_end1},{P2,P_end2},{P3,P_end3}};
% %polygon_list = {{P1,P_end1},{P1,P_end1},{P1,P_end1}};
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
for i=1:length(polygon_list)
    polygon = polygon_list{i};
%     P = polygon{1};
%     P_end = polygon{2};
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
    % checked, if these circles fit into the current polygon. If yes, the
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
    [radii,X,Z,radii_red,X_red,Z_red] = create_circles(polygon, number_circles_per_section, red_radius_factor);
    if ~isempty(remove_circle_parameters)
        accuracy_factor = remove_circle_parameters(1);
        min_area_remain = remove_circle_parameters(2);
        max_area_removed = remove_circle_parameters(3);
        [radii,X,Z] = remove_circles_proximity(radii,X,Z,radii_stay,X_stay,Z_stay,accuracy_factor);
        [radii,X,Z] = remove_circles(radii,X,Z,radii_red,X_red,Z_red,radii_stay,X_stay,Z_stay,min_area_remain,max_area_removed);
    else
        radii_stay = []; % reuse at most one time, if circles are not removed
        % Else, runtime would be very long.
        X_stay = [];
        Z_stay = [];
        indices_stay = [];
    end
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
    disp("Number of new green circles in section    : "+string(length(radii)))
    disp("Number of green circles reused from before: "+string(length(radii_stay)))
end

cylinders = {centers_left,centers_right,cylinder_radii};
cylinders_red = {centers_left_red,centers_right_red,cylinder_radii_red};

end

