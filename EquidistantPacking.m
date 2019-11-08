width = 10;
height = 5*sqrt(3);
r = 0.5;
[x,y] = meshgrid(1+0.5:2:19+0.5,sqrt(3)/3:2*sqrt(3):8*sqrt(3)+sqrt(3)/3);
[xx,yy] = meshgrid(0+0.5:2:18+0.5,sqrt(3)/3+sqrt(3):2*sqrt(3):9*sqrt(3)+sqrt(3)/3);
s1 = size(x);
s2 = size(xx);
X = zeros(s1(1)*s1(2)+s2(1)*s2(2),2);
for i = 1:s1(1)*s1(2)
    X(i,:) = [x(i),y(i)];
end
for i = 1:s2(1)*s2(2)
    X(i+s1(1)*s1(2),:) = [xx(i),yy(i)];
end
X = r.*X;
save('./RegularPackingData/HexagonalPacking10.mat','X','width','height')