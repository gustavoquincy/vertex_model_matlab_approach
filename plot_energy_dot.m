Z = zeros(length(v),1);
for i = 1:length(v)
    Z(i) = sum(v(i).Energy,'all');
end
ran = range(Z);
min_val = min(Z);
max_val = max(Z);
y = floor(((Z-min_val)/ran)*63)+1;
p = colormap(jet);
for i = 1:length(v)
    a = y(i);
    plot(v(i).Loc(1),v(i).Loc(2),'o','Color',p(a,:),'MarkerSize',20,'MarkerFaceColor',p(a,:))
    hold on
end
colorbar

%{
x=rand(20,1); %data to be plotted
ran=range(x); %finding range of data
min_val=min(x);%finding maximum value of data
max_val=max(x)%finding minimum value of data
y=floor(((x-min_val)/ran)*63)+1; 
col=zeros(20,3)
p=colormap
for i=1:20
  a=y(i);
  col(i,:)=p(a,:);
  stem3(i,i,x(i),'Color',col(i,:))
  hold on
end
%}