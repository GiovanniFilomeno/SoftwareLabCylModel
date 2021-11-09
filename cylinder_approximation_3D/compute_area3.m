% Computes the area by creating a 2D geometry, by approximating the circles
% by polygons
% By default, it returnes total_area = 0

function total_area = compute_area3(X, Y, radii, X_red, Y_red, radii_red)

total_area = 0;

polygon = create_polyshape(X, Y, radii, X_red, Y_red, radii_red);
if ~isempty(polygon)
    total_area = area(polygon);
end

end