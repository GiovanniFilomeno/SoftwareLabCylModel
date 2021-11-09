% plots 2D-circles in a 3D-space by approximating them as polygons
% It includes circles, which are added (green) and subtracted (red)
function plot_circles(radii,X,Y,radii_red,X_red,Y_red,y_values)

hold on
polygon = create_polyshape(X, Y, radii, X_red, Y_red, radii_red);
for y_value = y_values
    M=[ 1         0         0         0
        0         0	       -1         y_value
        0         1         0         0
        0         0         0         1];
    t=hgtransform('Matrix',M);     
    plot(polygon,'Parent',t,'FaceColor','g');
end

end

