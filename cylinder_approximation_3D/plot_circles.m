function plot_circles(radii,X,Y,radii_red,X_red,Y_red,P,P_end,min_points,max_points)

k = convhull(P);
inner_point = mean(P(k,:),1);

figure()
hold on

radius = sum(max_points)-sum(min_points);
xlim([inner_point(1)-radius,inner_point(1)+radius])
ylim([inner_point(2)-radius,inner_point(2)+radius])
axis square
%%
for i = 1:length(radii)%new_number_circles
    rectangle('Position',[X(i)-radii(i),Y(i)-radii(i),2*radii(i),2*radii(i)],'Curvature',[1,1], 'FaceColor','g'); % 'EdgeColor','g'
end
%%
for i = 1:length(radii_red)
    rectangle('Position',[X_red(i)-radii_red(i),Y_red(i)-radii_red(i),2*radii_red(i),2*radii_red(i)],'Curvature',[1,1], 'FaceColor','r'); % 'EdgeColor','g'
end

for i = 1:length(P)
    plot([P(i,1),P_end(i,1)],[P(i,2),P_end(i,2)],'linewidth',1,'color','blue')
end

%Note: inaccuracy in plot probably only visual problem (or round-off error)
%For small red circles, it works perfectly

hold off

% % Plot polygone
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

