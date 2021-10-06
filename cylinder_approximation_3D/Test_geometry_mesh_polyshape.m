clc; clear; close all;

% pgon = polyshape([0 0 1 1],[1 0 0 1]);
% plot(pgon)
% poly1 = polyshape([0 0 1 1 0.5 NaN 0.1 0.1 0.8 0.8],[1 0 0 1 1.5 NaN 0.8 0.1 0.1 0.8]);
% poly2 = polyshape([0.75 1.25 1.25 0.75],[0.25 0.25 0.75 0.75]);
% plot(poly1)
% hold on
% plot(poly2)
% polyout = intersect(poly1,poly2);
% plot(polyout)

% rect1 = [3
%     4
%     -1
%     1
%     1
%     -1
%     0
%     0
%     -0.5
%     -0.5];
% C1 = [1
%     1
%     -0.25
%     0.25];
% C2 = [1
%     -1
%     -0.25
%     0.25];
% C1 = [C1;zeros(length(rect1) - length(C1),1)];
% C2 = [C2;zeros(length(rect1) - length(C2),1)];
% gd = [rect1,C1,C2];
% ns = char('rect1','C1','C2');
% ns = ns';
% sf = '(((rect1)+C1)-C2)+C1';
% [dl,bt] = decsg(gd,sf,ns);
% [dl2,bt2] = csgdel(dl,bt);
% % figure
% % pdegplot(dl2,'EdgeLabels','on','FaceLabels','on')
% % xlim([-1.5,1.5])
% % axis equal
% pdegplot(dl2,'FaceLabels','on')
% % extrude(dl2,5) %%%%%%%%%%%%%%%%%%%%%%%%%%%% need Matlab R2020b!!!!

% gm = importGeometry('simple_cube.stl');
% pdegplot(gm)

% Test creation of polyshape
% poly1 = polyshape([0 1 1 0 NaN 0.1 0.8 0.8 0.1],[0 0 1 1 NaN 0.8 0.8 0.1 0.1]);
poly1 = polyshape([1 0 0 1 NaN 0.1 0.8 0.8 0.1],[1 1 0 0 NaN 0.8 0.8 0.1 0.1]);

plot(poly1)

hole_boundaries = ishole(poly1);
number_boundaries = length(hole_boundaries);
[x1,y1] = boundary(poly1,1)
[x2,y2] = boundary(poly1,2)