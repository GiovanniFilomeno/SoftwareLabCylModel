% Tests, if a given point lies inside a cylinder-structure
function is_inside = test_inside(X,Y,radii,x,y,n_green,n_red)
is_inside = false;
x_dist = X(1:n_green)-x;
y_dist = Y(1:n_green)-y;
radius = radii(1:n_green);
condition = x_dist.^2+y_dist.^2<radius.^2;
if sum(condition) > 0
    is_inside = true;
end
%This second part not yet tested
x_dist = X(n_green+1:end)-x;
y_dist = Y(n_green+1:end)-y;
radius = radii(n_green+1:end);
condition = x_dist.^2+y_dist.^2<radius.^2;
if sum(condition) > 0
    is_inside = false;
end
end