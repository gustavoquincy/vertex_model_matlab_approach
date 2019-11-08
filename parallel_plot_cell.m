function parallel_plot_cell(f,v)
%parallel cell plotting
tic
figure
D = parallel.pool.DataQueue;
D.afterEach(@(x) plotpolygon(x));
parfor i = 1:length(f)
    location = loc(v(f(i).Vertices));
    pgon = polyshape(location(:,1),location(:,2));
    send(D, pgon);
    %plot(pgon)
    %hold on
    c = f(i).Centroid;
    text(c(1),c(2),sprintf('%d',i),'FontSize',15);
    for j = 1:length(f(i).Vsize)
        text(location(j,1),location(j,2),sprintf('%d',f(i).Vertices(j)),'FontSize',15,'color','r');
    end
end
toc
end

function plotpolygon(pgon)
plot(pgon);
hold on
drawnow('limitrate');
end