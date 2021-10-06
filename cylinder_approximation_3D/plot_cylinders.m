function plot_cylinders(cylinders,cylinders_red,stlfile)

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

for y = linspace(y_min,y_max,100)
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
    plot_circles(radii(index_green),X(index_green),Z(index_green),radii_red(index_red),X_red(index_red),Z_red(index_red),y);
    
end

view([1,1,1])

% stlfile='simple_cube.stl'
% as=load('data.mat')
% cylinders= as.data
% 
% x = cylinders.x;
% y = cylinders.y;
% r=cylinders.r;
% hgt = y;
% th=0:pi/100:2*pi;
% figure
% hold on
% for M = 1:length(x)
%    
%         a=r(M)*cos(th);
%         b=r(M)*sin(th);
%         X1 =[a; a]+x(M);
%         Y1 =[b; b]+y(M);
%         Z1=[ones(1,size(th,2)); zeros(1,size(th,2))]*hgt(M);'FaceAlpha';
%         
%     
%     surf(X1,Z1,Y1);
% 
%     axis('equal')
%     
%       
% end
%  hold off
% 
% view(45,30)
% 
% %% Reading STL File from Input
% fv = stlread(stlfile);
% figure
% 
% 
% %% Render
% patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
%          'EdgeColor',       'none',        ...
%          'FaceLighting',    'gouraud',     ...
%          'AmbientStrength', 0.15);
% 
% % Add a camera light, and tone down the specular highlighting
% camlight('headlight');
% material('shiny');
% 
% % Fix the axes scaling, and set a nice view angle
% axis('image');
% view([-135 35]);
% 
% 
% 
% %% Plotting cyliner from Benjamine output

end


