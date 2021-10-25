function [radii,X,Y,radii_red,X_red,Y_red] = approximate_by_circles(polygon)

[P, P_end] = convert_polyshape(polygon);

number_points = length(P);
[lines_on_hull,inner_point] = find_lines_on_hull(P,P_end);

max_points = max(P);
min_points = min(P);
radius_max = sum(max_points)-sum(min_points);
large_radius = 10*radius_max;

max_number_circles = 40;
X = zeros(max_number_circles,1);
Y = zeros(max_number_circles,1);
radii = zeros(max_number_circles,1);

% Define green circles to approximate polygone
number_circles = 1;
segment_lengths = sqrt((P_end(:,1)-P(:,1)).^2+(P_end(:,2)-P(:,2)).^2);
cumulative_lengths = cumsum(segment_lengths);
perimeter = cumulative_lengths(end); % equal to perimeter(polygon)
distance = perimeter/max_number_circles;
for i = 1:max_number_circles
    position_on_perimeter = (i-0.5)*distance;
    line_index = find(cumulative_lengths>position_on_perimeter,1);
    length_on_line = cumulative_lengths(line_index)-position_on_perimeter;
    position = length_on_line/segment_lengths(line_index);
    
    [x_return,y_return,radius_return] = max_circle_touching_line(lines_on_hull,line_index,position,P,P_end,number_points,radius_max);
    if radius_return
        number_circles = number_circles+1;
        X(number_circles) = x_return;
        Y(number_circles) = y_return;
        radii(number_circles) = radius_return;
    end
end
% create 5 circles per line
% for line_loop = 1:number_points
%     for pos_loop = [linspace(0.05,0.2,2),linspace(0.3,0.7,3),linspace(0.8,0.95,2)]
%         [x_return,y_return,radius_return] = max_circle_touching_line(lines_on_hull,line_loop,pos_loop,P,P_end,number_points,radius_max);
%         if radius_return
%             number_circles = number_circles+1;
%             X(number_circles) = x_return;
%             Y(number_circles) = y_return;
%             radii(number_circles) = radius_return;
%         end
%     end
% end

number_circles = number_circles-1;
radii = radii(1:number_circles);
X = X(1:number_circles);
Y = Y(1:number_circles);

number_red_circles = sum(lines_on_hull);
X_red = zeros(number_red_circles,1);
Y_red = zeros(number_red_circles,1);
radii_red = ones(number_red_circles,1)*large_radius;
i_red = 1;
%Define red circles to approximate convex polygone
for i = 1:number_points
    if lines_on_hull(i)
        x1 = P(i,1);
        y1 = P(i,2);
        x2 = P_end(i,1);
        y2 = P_end(i,2);
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
            X_red(i_red) = cx1;
            Y_red(i_red) = cy1;
        else
            X_red(i_red) = cx2;
            Y_red(i_red) = cy2;
        end
        i_red = i_red + 1;
    end
end

% Test, if test_inside or isinterior is faster => test_inside is much
% faster
% % tic;
% % for i = 1:1000
% %     test_inside(X, Y, radii, X_red, Y_red, radii_red,0,0);
% % end
% % time_a = toc
% % tic;
% % for i = 1:1000
% %     isinterior(polygon,0,0);
% % end
% % time_b = toc

end

function [x_return,y_return,radius_return] = max_circle_touching_line(lines_on_hull,line_index,position,P,P_end,number_points,radius_max)

x_return = 0;
y_return = 0;
radius_return = 0;

x1 = P(line_index,1);
y1 = P(line_index,2);
x2 = P_end(line_index,1);
y2 = P_end(line_index,2);
tx = x2-x1; % Line vector
ty = y2-y1;
abs_t = sqrt(tx^2+ty^2);
tx_normal = tx/abs_t; % Normalized Line Vector
ty_normal = ty/abs_t;
% Normal vectors need to point inside, they do, if points are clockwise for
% outer boundaries and counterclockwise for boundaries of holes.
nx = ty_normal; % Normal vector
ny = -tx_normal;
x_touch = x1+position*tx;
y_touch = y1+position*ty;
radius = abs_t*8;
size_step = radius/2;
for size_loop = 1:20
    if radius > abs_t/32
        x_center = x_touch+nx*radius;
        y_center = y_touch+ny*radius;
        radius_ok = 1;
        for i = 1:number_points
            if (i ~= line_index)&&(lines_on_hull(i)==0)
                x_test1 = P(i,1);
                y_test1 = P(i,2);
                x_test2 = P_end(i,1);
                y_test2 = P_end(i,2);
                if check_intersection([x_test1,y_test1],[x_test2,y_test2],[x_center,y_center],radius)
                    radius_ok = 0;
                end
            end
        end
        if radius_ok
            x_return = x_center;
            y_return = y_center;
            radius_return = radius;
            radius = radius+size_step;
            if radius > radius_max
                radius = radius_max;
            end
        else
            radius = radius-size_step;
        end
    else
        break;
    end
    size_step = size_step/2;
end

end