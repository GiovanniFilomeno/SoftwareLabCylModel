function plot_cylinders(cylinders,stlfile)

stlfile='simple_cube.stl'
as=load('data.mat')
cylinders= as.data

x = cylinders.x;
y = cylinders.y;
r=cylinders.r;
hgt = y;
th=0:pi/100:2*pi;
figure
hold on
for M = 1:length(x)
   
        a=r(M)*cos(th);
        b=r(M)*sin(th);
        X1 =[a; a]+x(M);
        Y1 =[b; b]+y(M);
        Z1=[ones(1,size(th,2)); zeros(1,size(th,2))]*hgt(M);'FaceAlpha';
        
    
    surf(X1,Z1,Y1);

    axis('equal')
    
      
end
 hold off

view(45,30)

%% Reading STL File from Input
fv = stlread(stlfile);
figure


%% Render
patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);

% Add a camera light, and tone down the specular highlighting
camlight('headlight');
material('shiny');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);



%% Plotting cyliner from Benjamine output

end


