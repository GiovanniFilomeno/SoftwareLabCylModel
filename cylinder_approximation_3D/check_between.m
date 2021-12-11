function is_between = check_between(point1,point2,point)
% check_between determines, wether a point (which is assumed to lie on a
% line defined by points 1 and 2) is located between these 2 points
%| Inputs:
%         point1,point2: defines the line
%         point: point on that line, that is checked
%| Outputs:
%         is_between: boolean value, if the point is in between

t1x = point(1)-point1(1); % normal from point to points 1 and 2
t1y = point(2)-point1(2);
t2x = point(1)-point2(1);
t2y = point(2)-point2(2);
is_between = 1;
if t1x*t2x+t1y*t2y > 0 % if normals have same sign, point not between
    is_between = 0;
end
end