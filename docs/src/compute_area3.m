function total_area = compute_area3(X, Y, radii, X_red, Y_red, radii_red)
% 
% compute_area computes the area of a shape, which is defined by the
% addition of a set of (green) circles and subtraction of a set of (red)
% circles. It computes the area by approximating the given circles
% by polygons and computing the area of that polygon.
% By default, it returnes total_area = 0 (If the polygon-approximation
% cannot be created)
%
%Inputs:
%         :X,Y,radii: vectors of center-coordinates and radii of circles,
%                     which are combined to a shape
%         :X_red,Y_red, radii_red: vectors of center-coordinates and radii
%                                  of circles, which are subtracted from the shape
%Outputs:
%         :area: approximated area of the given shape

total_area = 0;

polygon = create_polyshape(X, Y, radii, X_red, Y_red, radii_red);
if ~isempty(polygon)
    total_area = area(polygon);
end

end