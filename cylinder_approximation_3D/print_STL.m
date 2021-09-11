function []=print_STL(V,F,color)

%Print the whole geometry 
AofT=length(F(:,1));

for i=1:AofT
    
    xt=V(i*3-2:i*3,1);
    yt=V(i*3-2:i*3,2);
    zt=V(i*3-2:i*3,3);
    fill3(xt,yt,zt,color);
    hold on 
end 

end