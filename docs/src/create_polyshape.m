function [polygon,polygon_red] = create_polyshape(X, Y, radii, X_red, Y_red, radii_red, n_sides)
% 
% create_polyshape defines a polygon, that approximates a 2D combination of
% circles. All circles are approximated by regular n-sided polygons. Then,
% some of the circles are added and the others are subtracted. That forms
% the final 2D-polygon.
%
%Inputs:
%         :X,Y,radii: vectors of center-coordinates and radii of circles,
%                     which are combined to a single shape
%         :X_red,Y_red, radii_red: vectors of center-coordinates and radii
%                                  of circles, which are subtracted from the shape
%         :n_sides: All circles are approximated by polygons with this
%                   number of sides.
%Outputs:
%         :polygon: the final shape approximated as a polygon given as a 
%                   polyshape-object
%         :polygon_red: The combination of all circles, which are
%                       subtracted. This is used to plot the subtracted region.

polyvec_green = polyshape(length(X),0);
polyvec_red = polyshape(length(X_red),0);

polygon = polyshape();
if nargin < 7
    n_sides = 600;
end
% Compute sidelength of polygon by comparing the area of the circle and the
% polygon
% area = n * a^2 * cot(pi/n) / 4
% area = r^2*pi
% a = r*sqrt(4*pi/n/cot(pi/n))

A = (sqrt(4.*pi./n_sides./cot(pi./n_sides)));
a=A(A~=0 & isfinite(A));
    
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