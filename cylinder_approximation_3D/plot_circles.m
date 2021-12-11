function [area_section] = plot_circles(radii,X,Y,radii_red,X_red,Y_red,y_values)
% plot_circles plots 2D-circles in a 3D-space by approximating them as polygons
% It includes circles, which are added (green) and subtracted (red). The
% circles are plotted at every y-plane of the given y-values. If exactly 2
% y-values are given, also the also side-faces are plotted, such that the
% resulting plot gives a closed 3D-geometry.
% As the area can be computed quickly from these polygon-approximations,
% also the area of the shape is computed and returned.
%| Inputs:
%|         X,Y,radii: vectors of center-coordinates and radii of circles,
%          which are combined to a single shape
%|         X_red,Y_red, radii_red: vectors of center-coordinates and radii
%          of circles, which are subtracted from the shape
%|         y_values: at these y_values, the 2D-geometries are plotted in
%          the according x-z-planes
%| Outputs:
%|        area_section: area of the given shape

hold on

polygon = create_polyshape(X, Y, radii, X_red, Y_red, radii_red, 400);
if length(y_values) == 2
    hole_boundaries = ishole(polygon); % gives logical array with length = number of boundaries
    number_boundaries = length(hole_boundaries);
    for i = 1:number_boundaries
        % Compute angles to determine colors.
        [points_x,points_y] = boundary(polygon,i); % First point is already equal to last point
        points_x_appended = [points_x(end-1);points_x]; % also append true last point before the first point
        points_y_appended = [points_y(end-1);points_y];
        vectors_x = points_x_appended(2:end)-points_x_appended(1:end-1);
        vectors_y = points_y_appended(2:end)-points_y_appended(1:end-1);
        scalar_products = vectors_x(1:end-1).*vectors_x(2:end)+vectors_y(1:end-1).*vectors_y(2:end);
        norms = sqrt(vectors_x.^2+vectors_y.^2);
        angles = acos(scalar_products./norms(1:end-1)./norms(2:end));
        for i = 1:length(angles)
            y_vec = [y_values(1),y_values(1),y_values(2),y_values(2)];
            x_vec = [points_x(i),points_x(i+1),points_x(i+1),points_x(i)];
            z_vec = [points_y(i),points_y(i+1),points_y(i+1),points_y(i)];
            if angles(i) < 2*pi/40
                color_edge = 'green';
            else
                color_edge = 'k';
            end
            fill3(x_vec,y_vec,z_vec,'green','EdgeColor',color_edge);
        end
    end
end

polygon = create_polyshape(X, Y, radii, X_red, Y_red, radii_red, 600);
if ~isempty(y_values)
    for y_value = y_values
        M=[ 1         0         0         0
            0         0	       -1         y_value
            0         1         0         0
            0         0         0         1];
        t=hgtransform('Matrix',M);     
        plot(polygon,'Parent',t,'FaceColor','g','FaceAlpha',1,'LineWidth',1);
    end
else
    plot(polygon,'FaceColor','g','FaceAlpha',1);
end

area_section = area(polygon);

end

