function [simplex, vertex, width, height] = construct_object(file)
load(file,'X','width','height')
cell = length(X);
%elongate X to copy the [0,1]*[0,1] to its outer
X = [X;X+[width,0];X+[width,height];X+[0,height];X+[-width,-height];X+[-width,0];X+[0,-height];X+[width,-height];X+[-width,height]];
%X = [X];
[V, F] = voronoin(X, {'Qbb'});
X = X(1:cell);

Vindex=[];
for i=1:cell
    Vindex=union(Vindex,F{i});
end
vertices = length(Vindex); %Vindex stores the mapping
vertex(vertices) = Vertex(); %initialize object array
for i=1:vertices
    k=V(Vindex(i),:);
    vertex(i)=Vertex(k(1),k(2));
end
simplex(cell) = Simplex();
for i=1:cell
    set = F{i};
    for j=1:length(F{i})
        set(j) = find(Vindex==set(j));
    end
    simplex(i)=Simplex(set);
    simplex(i).Vsize = length(set);
end
end
