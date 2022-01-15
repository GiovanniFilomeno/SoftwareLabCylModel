function is_inside = test_inside(X,Y,radii,X_red,Y_red,radii_red,x,y)
% is_inside tests, if a given point lies inside a shape, that is defined by
% circles. The shape is defined by the addition of (green) circles and
% the subtraction of (red) circles.
%
%Inputs:
%         :X,Y,radii: vectors of center-coordinates and radii of circles,
%                      which are combined to a single shape
%         :X_red,Y_red, radii_red: vectors of center-coordinates and radii
%                                   of circles, which are subtracted from the shape
%         :x,y: coordinates of a point, which is tested
%Outputs:
%         :is_inside: logical value, that is 1, if the point lies inside the
%                     given shape

is_inside = false;
x_dist = X-x;
y_dist = Y-y;
condition = x_dist.^2+y_dist.^2<radii.^2;
if sum(condition) > 0
    is_inside = true;
end

x_dist = X_red-x;
y_dist = Y_red-y;
condition = x_dist.^2+y_dist.^2<radii_red.^2;
if sum(condition) > 0
    is_inside = false;
end
end