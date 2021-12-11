function [mesh_list, y_values] = create_sections(F,V,N,number_of_sections_or_vector)
% create_sections cuts the given geometry into several sections. If a 
% number is given, it splits the geometry into that number of sections
% with uniform thickness. If a vector of y-values is given, it cuts the 
% geometry at these y-values. The cuts are performed at x-z-planes at the 
% corresponding y-values.
%| Inputs:
%         F,V,N: faces, vertices and normal-vectors of the given geometry
%         number_of_sections_or_vector: if it's a number, the geometry is
%         cut into this number of uniformly thick sections. If it's a
%         vector, these are the y-values, at which the geometry is cut.
%| Outputs:
%         mesh_list: The geometry of each section, stl-like-datastructure. It
%         consists of faces, vertices and normal vectors
%         y_values: array of length mesh_list + 1, stores all y_values
%         between the sections and at the ends of the complete geometry

if(length(number_of_sections_or_vector)==1)
    YminGEO=min(V(:,2));
    YmaxGEO=max(V(:,2));
    delta=(YmaxGEO-YminGEO)/(number_of_sections_or_vector);

    YcutGEO=zeros(number_of_sections_or_vector+1,1);
    for r=1:number_of_sections_or_vector+1%parfor r=1:number_of_sections+1
        YcutGEO(r)=YminGEO+delta*(r-1);
    end
else
    YcutGEO=number_of_sections_or_vector;
end
% YcutGEO = [-365,-270,-211,-165,-125,-110,30,211,365];%%%%%%%%%%%
y_values=YcutGEO;
mesh_list = cell(length(YcutGEO)-1,3);


for i=1:(length(YcutGEO)-2)
    
    [FGR,VGR,NGR,FRD,VRD,NRD]=cut_the_geometry(F,V,N,YcutGEO(i+1));

    mesh_list{i,1}=FGR;
    mesh_list{i,2}=VGR;
    mesh_list{i,3}=NGR;

    F=FRD;
    V=VRD;
    N=NRD;

end
% The rightmost mesh_list is the remaining mesh, after all cuttings
mesh_list{end,1}=F;
mesh_list{end,2}=V;
mesh_list{end,3}=N;

% for i=1:(length(y_values)-1)
%     figure();
%     plot_STL(mesh_list{i,2},mesh_list{i,1});
%     axis equal;
% end


end

 


