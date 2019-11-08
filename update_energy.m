function [simplex, vertex] = update_energy(vindex,simplex,vertex,dx,dy)
%UPDATE_ENERGY recalculate affected parameters when one single vertex is
%moved, i.e, neighbor face area(3), perimeter(3), vertex-vertex junction
%length(3)
%used for PERTURB function for finding gradient
set1 = [vindex, vertex(vindex).Dual];
set2 = vertex(vindex).Edge(:,2)';
face = vertex(vindex).N_Face;
for i = 1:length(set1)
    vertex(set1(i)).Loc = vertex(set1(i)).Loc + [dx,dy];
end
simplex = update_area(vindex,simplex,vertex);%also update perimeter
U = zeros(3,length(face));
for i = 1:length(face)
    f = face(i);
    U(1,i) = simplex(f).K/2*(simplex(f).Area-simplex(f).A0)^2;
    U(2,i) = simplex(f).Gamma/2*(simplex(f).Perimeter)^2;
    U(3,i) = vertex(vindex).Delta(i)*vnorm(vertex(vindex).Edge(i,1),vertex(vindex).Edge(i,2),vertex);
end
%every block in the 3*3 energy block should be updated for set1 element
for i = 1:length(set1)
    vertex(set1(i)).Energy = U;
    vertex(set1(i)).UpdateFlag = true;
end
for i = 1:length(set2)
    face2 = vertex(set2(i)).N_Face;
    [~, IA, IB] = intersect(face, face2, 'stable');
    vertex(set2(i)).Energy(1:2,IB(1)) = U(1:2,IA(1));
    vertex(set2(i)).Energy(1:2,IB(2)) = U(1:2,IA(2));
    [~, IA, ~] = intersect(edge(vertex(set2(i))), [vindex, vertex(vindex).Dual], 'stable');
    vertex(set2(i)).Energy(3,IA) = U(3,i);
    vertex(set2(i)).UpdateFlag = true;
    if ~isempty(vertex(set2(i)).Dual)
        vertex = update_dual(set2(i),vertex);
    end
end
for i =1:length(face)
    f = simplex(face(i));
    vset = f.Vertices;
    for j = 1:length(vset)
        if vertex(vset(j)).UpdateFlag == false
            findex = vertex(vset(j)).N_Face == face(i);
            vertex(vset(j)).Energy(1:2,findex) = U(1:2,i);
            vertex(vset(j)).UpdateFlag = true;
        end
    end
end
end

function simplex = update_area(vindex, simplex, vertex)
%UPDATE_AREA also update perimeter, the same as function CALC_AREA
face = vertex(vindex).N_Face;
for i = 1:length(face)
    vset = simplex(face(i)).Vertices;
    location = zeros(length(vset),2);
    for j = 1:length(vset)
        location(j,:) = vertex(vset(j)).Loc;
    end
    pgon = polyshape(location(:,1),location(:,2));
    simplex(face(i)).Area = area(pgon);
    simplex(face(i)).Perimeter = perimeter(pgon);
end
end

function vertex = update_dual(vindex, vertex)
dual = vertex(vindex).Dual;
for i = 1:length(dual)
    vertex(dual(i)).Energy = vertex(vindex).Energy;
    vertex(dual(i)).UpdateFlag = true;
end
end

