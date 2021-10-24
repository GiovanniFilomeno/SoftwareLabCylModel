function plot_circles(radii,X,Y,radii_red,X_red,Y_red,y_values)
%function plot_circles(radii,X,Y,radii_red,X_red,Y_red,P,P_end,min_points,max_points,y_value)
% k = convhull(P);
% inner_point = mean(P(k,:),1);
% 
hold on
polygon = create_polyshape(X, Y, radii, X_red, Y_red, radii_red);
for y_value = y_values
    M=[ 1         0         0         0
        0         0	       -1         y_value
        0         1         0         0
        0         0         0         1];
    t=hgtransform('Matrix',M);     
    plot(polygon,'Parent',t,'FaceColor','g');
end

%%
% radius = sum(max_points)-sum(min_points);
% xlim([inner_point(1)-radius,inner_point(1)+radius])
% zlim([inner_point(2)-radius,inner_point(2)+radius])
% % % % % axis square
%%
% Old way of plotting
% % teta=0:0.01:2*pi ;
% % for i = 1:length(radii)%new_number_circles
% %     x = X(i)+radii(i)*cos(teta);
% %     y = y_value+zeros(size(x)) ;
% %     z = Y(i)+radii(i)*sin(teta);
% %     patch(x,y,z,'g')
% %     %rectangle('Position',[X(i)-radii(i),Y(i)-radii(i),2*radii(i),2*radii(i)],'Curvature',[1,1], 'FaceColor','g'); % 'EdgeColor','g'
% % end
% % for i = 1:length(radii_red)
% %     x = X_red(i)+radii_red(i)*cos(teta);
% %     y = y_value+zeros(size(x));
% %     z = Y_red(i)+radii_red(i)*sin(teta);
% %     patch(x,y,z,'r');
% %     %rectangle('Position',[X_red(i)-radii_red(i),Y_red(i)-radii_red(i),2*radii_red(i),2*radii_red(i)],'Curvature',[1,1], 'FaceColor','r'); % 'EdgeColor','g'
% % end
% for i = 1:length(P)
%     plot3([P(i,1),P_end(i,1)],[y_value,y_value],[P(i,2),P_end(i,2)],'linewidth',1,'color','blue')
% end
% % 
% % %Note: inaccuracy in plot probably only visual problem (or round-off error)
% % %For small red circles, it works perfectly
% % 
% % hold on

%% Plot polygone
% figure();
% radius = sum(max_points)-sum(min_points);
% xlim([inner_point(1)-radius,inner_point(1)+radius])
% ylim([inner_point(2)-radius,inner_point(2)+radius])
% axis square
% hold on
% for i = 1:length(P)
%     plot([P(i,1),P_end(i,1)],[P(i,2),P_end(i,2)],'linewidth',4,'color','blue')
% end
% % for i = 1:length(P)
% %     if lines_on_hull(i)
% %         plot([P(i,1),P_end(i,1)],[P(i,2),P_end(i,2)],'--','linewidth',4,'color','red')
% %     end
% % end
% plot(P(k,1),P(k,2),'--','linewidth',1,'color','red');
% hold off

end

