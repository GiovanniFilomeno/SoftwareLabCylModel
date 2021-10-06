% Computes the area by creating a 2D geometry, automatically mesh it and
% then compute the area, all using the PDE toolbox.

% This method takes longer, than the old one (based on monte-carlo)

function total_area = compute_area2(X, Y, radii, X_red, Y_red, radii_red)

% Create the 2D-geometry
number_circles = length(X)+length(X_red);
description_matrix = zeros(4,number_circles);
description_matrix(1,:) = ones(1,number_circles);
description_matrix(2,1:length(X)) = X;
description_matrix(2,length(X)+1:number_circles) = X_red;
description_matrix(3,1:length(X)) = Y;
description_matrix(3,length(X)+1:number_circles) = Y_red;
description_matrix(4,1:length(X)) = radii;
description_matrix(4,length(X)+1:number_circles) = radii_red;

names = {};
for i = 1:number_circles
    name = "circle"+num2str(i);
    names{i} = char(name);
end
set_formula = string(repelem('(',number_circles-1)) + names{1};
for i = 2:length(X) % Add green circles
    set_formula = set_formula + ")+" + names{i};
end
for i = length(X)+1:number_circles % Subtract red circles
    set_formula = set_formula + ")-" + names{i};
end
names = char(names);
names = names';

[geometry_matrix,bt] = decsg(description_matrix,set_formula,names);
[geometry_matrix2,bt2] = csgdel(geometry_matrix,bt);
pdegplot(geometry_matrix2)

model = createpde;
geometryFromEdges(model,geometry_matrix2)
mesh = generateMesh(model);
pdeplot(mesh);
total_area = area(mesh);

end