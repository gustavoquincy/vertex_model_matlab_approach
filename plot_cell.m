function plot_cell(f,v,width,height,v_index)
figure('units','normalized','outerposition',[1 1 0.65 1]);
%figure('units','normalized','outerposition',[1 1 1 1]);
%%
%two options
plot_face_index = true;
plot_vertex_index = true;

if ~exist('v_index','var')
    plot_vertex_index=false;
end
%%  
[r,l] = ver(f(:));
l = cumsum(l);
l0 = circshift(l,1)+1;
l0(1) = 1;
%tic
%ticBytes(gcp);
y = floor(stateu(f)*63)+1;
p = colormap(jet);
for i =1:length(l)
    a = y(i);
    vcoor = loc(v(r(l0(i):l(i))));
    pgon = polyshape(vcoor(:,1),vcoor(:,2));
    plot(pgon,'FaceColor',p(a,:),'FaceAlpha',1,'EdgeColor',1-p(a,:),'EdgeAlpha',0.5);
    axis([-width./5 6*width./5 -height./5 6*height./5]);
    c = colorbar;
    c.Label.String = 'Corson Cell State';
    [warnMsg,~]=lastwarn;
    if ~isempty(warnMsg)
        warning('Simplex%d has received polyshape object warning. \n',i);
    end
    hold on
    if plot_face_index == true
        text(f(i).Centroid(1),f(i).Centroid(2),{sprintf('%d',i)},'FontSize',15,'color',1-p(a,:));
    end
end
%tocBytes(gcp)
if plot_vertex_index == true
    for i = 1:length(v)
        vcoor = loc(v(i));
        %index = (1:length(v));
        text(vcoor(1),vcoor(2),{sprintf('%d',i)},'FontSize',15,'color',1-p(a,:));
    end
end
end