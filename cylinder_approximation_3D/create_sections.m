function [mesh_list, y_values] = create_sections(F,V,N,number_of_sections)

% mesh_list = [[F,V,N],[F,V,N],...] for each section
% y_values has length number_of_sections + 1 (each section bottom and top)

% Read the original geometry
%[F,V,N] = stlread("Example.stl");
[F,V,N] = stlread("Pyramid Shape.stl");

XminGEO=min(V(:,1));
XmaxGEO=max(V(:,1));
%XcutGEO=linspace(XminGEO,XmaxGEO,number_of_sections);

%XcutGEO=[0 50 150 190 300 400 550 600];
XcutGEO=[-20 -15 -5 5 15 20];

y_values=XcutGEO;
mesh_list = cell((length(XcutGEO)-1),3);


for i=1:(length(XcutGEO)-2)
    
%1 CUT
[VGR,NGR,FGR,VRD,NRD,FRD]=cut_the_geometry(V,N,F,XcutGEO(i+1));

mesh_list{i,1}=FGR;
mesh_list{i,2}=VGR;
mesh_list{i,3}=NGR;

V=VRD;
N=NRD;
F=FRD;

if i==(length(XcutGEO)-2)
    mesh_list{i+1,1}=FRD;
    mesh_list{i+1,2}=VRD;
    mesh_list{i+1,3}=NRD;
end

end

color=['g';'m';'b';'g';'m';'b';'g'];

for j=1:(length(XcutGEO)-1)
    
    print_STL( mesh_list{j,2}, mesh_list{j,1},color(j));
    hold on
    
end


end

