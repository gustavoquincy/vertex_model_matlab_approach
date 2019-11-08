function perturb(vindex,simplex,vertex)
%PERTURB Summary of this function goes here
%   Detailed explanation goes here
x0 = vertex(vindex).Loc(1);
y0 = vertex(vindex).Loc(2);
x = -0.1:0.01:0.1;
y = -0.1:0.01:0.1;
[X,Y] = meshgrid(x0+x,y0+y);
lx = length(x);
ly = length(y);
F = zeros(lx,ly);
tic
ticBytes(gcp);
parfor i = 1:lx
    for j = 1:ly
        [s, v] = update_energy(vindex, simplex, vertex, x(i), y(j));
        F(j,i) = associated_u(vindex,s,v);
    end
end
tocBytes(gcp)
toc
figure
contour(X,Y,F,20,'ShowText','on')
%surf(X,Y,F)
hold on 
[pX, pY] = gradient(F);
index = find((X==x0)&(Y==y0));
f_grad = [pX(index) pY(index)]
hold on
quiver(X,Y,pX,pY)
hold on
xlabel('X');
ylabel('Y');
zlabel('associated energy');
hold on 
%plot3(x0,y0,associated_u(vindex,simplex,vertex),'r.','MarkerSize',40)
plot(x0,y0,'r.','MarkerSize',40)
text(x0+0.01, y0, {sprintf('%d',vindex)}, 'FontSize', 15, 'color','r');
hold off
end


