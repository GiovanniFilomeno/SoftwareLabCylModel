function [mesh_list, y_values] = create_sections(F,V,N,number_of_sections)

% Read the original geometry
[F,V,N] = stlread("simple_cube.stl");

YminGEO=min(V(:,2));
YmaxGEO=max(V(:,2));
number_of_sections=7;
delta=(YmaxGEO-YminGEO)/number_of_sections;

YcutGEO=[YminGEO (YminGEO+delta*1) (YminGEO+delta*2) (YminGEO+delta*3) (YminGEO+delta*4) (YminGEO+delta*5) (YminGEO+delta*6)];
y_values=YcutGEO;
mesh_list = cell((length(YcutGEO)),3);


for i=1:(length(YcutGEO)-1)
    
    [FGR,VGR,NGR,FRD,VRD,NRD]=cut_the_geometryV2(F,V,N,YcutGEO(i+1));

    mesh_list{i,1}=FGR;
    mesh_list{i,2}=VGR;
    mesh_list{i,3}=NGR;

    F=FRD;
    V=VRD;
    N=NRD;

    if i==(length(YcutGEO)-1)
        mesh_list{i+1,1}=FRD;
        mesh_list{i+1,2}=VRD;
        mesh_list{i+1,3}=NRD;
    end

end

color=['g';'m';'b';'g';'m';'b';'g'];

for j=1:(length(YcutGEO))
    
    print_STL( mesh_list{j,2}, mesh_list{j,1},color(j));
    hold on
    
end

end

 


