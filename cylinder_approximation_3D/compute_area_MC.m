function area = compute_area_MC(X, Y, radii, X_red, Y_red, radii_red, bounds_x, bounds_y)
% compute_area computes the area of a shape, which is defined by the
% addition of a set of (green) circles and subtraction of a set of (red)
% circles. It computes the area using a Monte Carlo algorithm. It creates
% some random points that follow a uniform distribution inside a
% bounding-box. Then, it tests for each point, if it is part of the geometry.
% Then, it computes the area by computing the fracition of points, 
% which lie inside the geometry and multiplying it with the area of the
% bounding box.
%| Inputs:
%         X,Y,radii: vectors of center-coordinates and radii of circles,
%         which are combined to a shape
%         X_red,Y_red, radii_red: vectors of center-coordinates and radii
%         of circles, which are subtracted from the shape
%         bounds_x,bounds_y: bounding box, which lies around the given
%         shape.
%| Outputs:
%         area: approximated area of the given shape

number = 100000;
length_x = bounds_x(2)-bounds_x(1);
length_y = bounds_y(2)-bounds_y(1);
x_tests = bounds_x(1)+length_x*rand(1,number);
y_tests = bounds_y(1)+length_y*rand(1,number);
results = zeros(1,number);
parfor i = 1:number
    results(i) = test_inside(X,Y,radii,X_red,Y_red,radii_red,x_tests(i),y_tests(i));
end
area = length_x*length_y*mean(results);
end