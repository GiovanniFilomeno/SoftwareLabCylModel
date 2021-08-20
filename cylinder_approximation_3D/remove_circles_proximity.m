% Remove circles, which have centers very close to each other.
function [radii,X,Y,new_number_circles] = remove_circles_proximity(number_circles,radii,X,Y,min_points,max_points)

radii = radii(1:number_circles);
X = X(1:number_circles);
Y = Y(1:number_circles);
[X,sorted_indices] = sort(X,'ascend');
Y = Y(sorted_indices);
radii = radii(sorted_indices);

X_check = X(1);
Y_check = Y(1);
radius_check = radii(1);
accuracy_factor = 0.01;
accuracy = accuracy_factor*radius_check;
index_check = 1;

for i = 2:number_circles
    for j = i:number_circles
        if (X(j)-X_check)^2+(Y(j)-Y_check)^2 < accuracy
            if radii(i) > radius_check
                radii(index_check) = 0;
                X_check = X(j);
                Y_check = Y(j);
                radius_check = radii(j);
                accuracy = accuracy_factor*radius_check;
                index_check = j;
            else
                radii(j) = 0;
            end
        end
        X_check = X(i);
        Y_check = Y(i);
        radius_check = radii(i);
        accuracy = accuracy_factor*radius_check;
        index_check = i;
    end
end

remaining_indices = find(radii);
new_number_circles = length(remaining_indices);
X = X(remaining_indices);
Y = Y(remaining_indices);
radii = radii(remaining_indices);

end

