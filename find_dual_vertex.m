function vertex = find_dual_vertex(vertex,width,height)
l = length(vertex);
for i = 1:l
    for j = i+1:l
        diff = vertex(i).Loc-vertex(j).Loc;
        x = abs(diff(1));
        y = abs(diff(2));
        if (abs(x-width)<=1e-10&&abs(y-0)<=1e-10) || (abs(x-0)<=1e-10&&abs(y-height)<=1e-10) || (abs(x-width)<=1e-10&&abs(y-height)<=1e-10)
            vertex(i) = add_dual(vertex(i), j);
            vertex(j) = add_dual(vertex(j), i);
        end
    end
end
