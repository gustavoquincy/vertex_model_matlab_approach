function [f, v] = update_simplex_parameter(f, v)
%r=-1 for ccw orientation of vertices
%r=1 for cw orientation of vertices
for i = 1:length(f)
    location = loc(v(f(i).Vertices));
    a = 0;
    p = 0;
    for j = 1:size(location,1)-1
        a = a+det(location(j:j+1,:));
        p = p+norm(location(j,:)-location(j+1,:));
    end
    p = p+norm(location(f(i).Vsize,:)-location(1,:));
    a = a+det([location(size(location,1),:);location(1,:)]);
    f(i).Orientation = -sign(a);
    f(i).Area = abs(a)./2;
    f(i).Perimeter = p;
    f(i).Centroid = mean(location,1);
end

