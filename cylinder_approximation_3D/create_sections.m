function [mesh_list, y_values] = create_sections(F,V,N,number_of_sections_or_vector)


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

y_values=YcutGEO;
mesh_list = cell((length(YcutGEO)),3);


for i=1:(length(YcutGEO)-1)
    
    [FGR,VGR,NGR,FRD,VRD,NRD]=cut_the_geometry(F,V,N,YcutGEO(i+1));

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

% for i=1:(length(y_values)-1)
%     print_STL(mesh_list{i,2},mesh_list{i,1});
% end


end

 


