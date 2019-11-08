function plot_boundingbox(width,height)
%plot bounding box
bounding_box=[0,0;width,0;width,height;0,height;0,0];
plot(bounding_box(:,1),bounding_box(:,2),'k','LineWidth',1);
end