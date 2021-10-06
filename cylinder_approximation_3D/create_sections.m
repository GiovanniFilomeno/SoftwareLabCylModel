function [mesh_list, y_values] = create_sections(F,V,N,number_of_sections)

% Read the original geometry

YminGEO=min(V(:,2));
YmaxGEO=max(V(:,2));
delta=(YmaxGEO-YminGEO)/number_of_sections;

YcutGEO=[YminGEO (YminGEO+delta*1) (YminGEO+delta*2) (YminGEO+delta*3) (YminGEO+delta*4) (YminGEO+delta*5) (YminGEO+delta*6)];
y_values=[YcutGEO,YmaxGEO];
mesh_list = cell((length(YcutGEO)),3);


for i=1:(length(YcutGEO)-1)
    
    [FGR,VGR,NGR,FRD,VRD,NRD]=cut_the_geometry(F,V,N,YcutGEO(i+1));%%%%%%%%%%%

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

% Print/plot final stl
% % % color=['g';'m';'b';'g';'m';'b';'g'];
% % % 
% % % for j=1:(length(YcutGEO))
% % %     
% % %     print_STL( mesh_list{j,2}, mesh_list{j,1},color(j));
% % %     hold on
% % %     
% % % end


% Generate the polygones for each slice

% Vertices 
for i=1:(length(YcutGEO))
    
    v=mesh_list{i,2};
    leng=length(v(:,2));

    % Interception
    I=zeros(1,3);
    counterI=0;
    %looping in the vertices 
    for j=1:leng
        
        if (i==(length(YcutGEO)))
            diff=abs(v(j,2)-YmaxGEO);
        else 
            diff=abs(v(j,2)-YcutGEO(i+1));
        end 
        if (diff<10^-6)
            counterI=counterI+1;
            I(counterI,:)=[v(j,1) v(j,2) v(j,3)];
        end
    end
    
    %print the points

% % %     lengthI=length(I);
% % %     for k=1:lengthI
% % %         plot3(I(k,1),I(k,2),I(k,3),'*')
% % %         hold on 
% % %     end
    
end
end

 


