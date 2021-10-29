function plot_cylinders(cylinders,cylinders_red,y_values)

figure();
axis equal

centers_left = cylinders{1,1};
centers_right = cylinders{1,2};
cylinder_radii = cylinders{1,3};
centers_left_red = cylinders_red{1,1};
centers_right_red = cylinders_red{1,2};
cylinder_radii_red = cylinders_red{1,3};
number_green_cylinders = length(cylinder_radii);
number_red_cylinders = length(cylinder_radii_red);

y_min = min(centers_left(:,2));
y_max = max(centers_right(:,2));

number_per_section = fix(200/(length(y_values)-1));
for y_index = 1:length(y_values)-1
    y = (y_values(y_index)+y_values(y_index+1))/2;
    X = zeros(1,number_green_cylinders);
    Z = zeros(1,number_green_cylinders);
    radii = zeros(1,number_green_cylinders);
    for i = 1:number_green_cylinders
        if (y>=centers_left(i,2)) && (y<=centers_right(i,2))
            X(i) = centers_left(i,1);
            Z(i) = centers_left(i,3);
            radii(i) = cylinder_radii(i);
        end
    end
    X_red = zeros(1,number_red_cylinders);
    Z_red = zeros(1,number_red_cylinders);
    radii_red = zeros(1,number_red_cylinders);
    for i = 1:number_red_cylinders
        if (y>=centers_left_red(i,2)) && (y<=centers_right_red(i,2))
            X_red(i) = centers_left_red(i,1);
            Z_red(i) = centers_left_red(i,3);
            radii_red(i) = cylinder_radii_red(i);
        end
    end
    [~,index_red] = find(radii_red);
    [~,index_green] = find(radii);
    y_positions = linspace(y_values(y_index),y_values(y_index+1),number_per_section);
    plot_circles(radii(index_green),X(index_green),Z(index_green),radii_red(index_red),X_red(index_red),Z_red(index_red),y_positions);
end

view([1,1,1])

end


