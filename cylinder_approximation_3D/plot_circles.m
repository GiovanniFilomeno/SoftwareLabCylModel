% plots 2D-circles in a 3D-space by approximating them as polygons
% It includes circles, which are added (green) and subtracted (red)
function plot_circles(radii,X,Y,radii_red,X_red,Y_red,y_values)

hold on

polygon = create_polyshape(X, Y, radii, X_red, Y_red, radii_red, 100);
if length(y_values) == 2
    [P,P_end] = convert_polyshape(polygon);
    for i = 1:size(P,1)
        y_vec = [y_values(1),y_values(1),y_values(2),y_values(2)];
        x_vec = [P(i,1),P_end(i,1),P_end(i,1),P(i,1)];
        z_vec = [P(i,2),P_end(i,2),P_end(i,2),P(i,2)];
        fill3(x_vec,y_vec,z_vec,'green','EdgeColor','k');
    end
end

polygon = create_polyshape(X, Y, radii, X_red, Y_red, radii_red);
for y_value = y_values
    M=[ 1         0         0         0
        0         0	       -1         y_value
        0         1         0         0
        0         0         0         1];
    t=hgtransform('Matrix',M);     
    plot(polygon,'Parent',t,'FaceColor','g','FaceAlpha',1,'LineWidth',1);
end

end

