function [totalVolume,totalArea] = stlVolume(V,F,N)
% stlVolume computes the volume of a geometry.
% Given a surface triangulation, compute the volume enclosed using
% divergence theorem.
% Assumption: Triangle nodes are ordered correctly, i.e.,computed normal is outwards
% Input: p: (3xnPoints), t: (3xnTriangles)
% Output: total volume enclosed, and total area of surface  
% Author: K. Suresh; suresh@engr.wisc.edu
% Adjusted by: Benjamin Sundqvist

V = V';
F = F';
N = N';

% Compute the vectors d13 and d12
d13= [(V(1,F(2,:))-V(1,F(3,:))); (V(2,F(2,:))-V(2,F(3,:)));  (V(3,F(2,:))-V(3,F(3,:)))];
d12= [(V(1,F(1,:))-V(1,F(2,:))); (V(2,F(1,:))-V(2,F(2,:))); (V(3,F(1,:))-V(3,F(2,:)))];
cr = cross(d13,d12,1);%cross-product (vectorized)
area = 0.5*sqrt(cr(1,:).^2+cr(2,:).^2+cr(3,:).^2);% Area of each triangle
totalArea = sum(area);
%crNorm = sqrt(cr(1,:).^2+cr(2,:).^2+cr(3,:).^2);
zMean = (V(3,F(1,:))+V(3,F(2,:))+V(3,F(3,:)))/3;
%nz = -cr(3,:)./crNorm;% z component of normal for each triangle
volume = area.*zMean.*N(3,:); % contribution of each triangle
totalVolume = sum(volume);%divergence theorem