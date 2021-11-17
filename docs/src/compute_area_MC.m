% Computes the area by computing the fraction of the area inside the
% bounding box
function area = compute_area(X, Y, radii, X_red, Y_red, radii_red, bounds_x, bounds_y)
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