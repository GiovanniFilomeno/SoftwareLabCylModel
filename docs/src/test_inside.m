% Tests, if a given point lies inside a circle-structure
function is_inside = test_inside(X,Y,radii,X_red,Y_red,radii_red,x,y)
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