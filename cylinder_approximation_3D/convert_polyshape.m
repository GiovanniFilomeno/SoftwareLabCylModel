% Converts polyshape objects into my own format for polygons
function [P, P_end] = convert_polyshape(polygon)
% For the following: I think, boundaries of interior are always
    % clockwise and boundaries of holes always counterclockwise
    % If not, this will not work!!!!!!!!!!!!!!!!!!!!!!!
    
    % P: array of all points of polygons
    % P_end: defines lines, has the same length as P
    % Note:
    % polygons need to be defined clockwise
    % Holes inside polygons need to be defined counterclockwise
    
    
    P = [];
    P_end = [];
    hole_boundaries = ishole(polygon); % gives logical array with length = number of boundaries
    number_boundaries = length(hole_boundaries);
    for i = 1:number_boundaries
        [points_x,points_y] = boundary(polygon,i);
        P_new = zeros(length(points_x)-1,2);
        P_new(:,1) = points_x(1:end-1);
        P_new(:,2) = points_y(1:end-1);
        P_end_new = zeros(length(points_x)-1,2);
        P_end_new(:,1) = points_x(2:end);
        P_end_new(:,2) = points_y(2:end);
        P = [P;P_new];
        P_end = [P_end;P_end_new];
    end
end

