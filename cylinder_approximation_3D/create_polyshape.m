function polygon = create_polyshape(X, Y, radii, X_red, Y_red, radii_red)

polyvec_green = polyshape.empty(length(X),0);
polyvec_red = polyshape.empty(length(X_red),0);

polygon = polyshape.empty();

n_sides = 400;
% Compute sidelength of polygon by comparing the area of the circle and the
% polygon
% area = n * a^2 * cot(pi/n) / 4
% area = r^2*pi
% a = r*sqrt(4*pi/n/cot(pi/n))
a = sqrt(4*pi/n_sides/cot(pi/n_sides));
if isfinite(a)
    for i = 1:length(X) % Add green circles
        if radii(i)>0
            polyvec_green(i) = nsidedpoly(n_sides,'Center',[X(i), Y(i)],'SideLength',a*radii(i));
        end
    end
    for i = 1:length(X_red) % Subtract red circles
        if radii_red(i)>0
            polyvec_red(i) = nsidedpoly(n_sides,'Center',[X_red(i), Y_red(i)],'SideLength',a*radii_red(i));
        end
    end

    if ~isempty(polyvec_green)
        polygon_green = union(polyvec_green);
        if ~isempty(polyvec_red)
            polygon_red = union(polyvec_red);
            polygon = subtract(polygon_green,polygon_red);
        else
            polygon = polygon_green;
        end
    end

end