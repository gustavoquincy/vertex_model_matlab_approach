function r = analytic_force(vindex,f,v,width,height)
[ccw,v] = ccwindex(vindex,f,v,width,height);
v0 = v(vindex);
v1 = v(ccw(1));
f1 = f(ccw(2));
v2 = v(ccw(3));
f2 = f(ccw(4));
v3 = v(ccw(5));
f3 = f(ccw(6));
edgerowv = [GammaP(f1)+Delta(v0,v1)+GammaP(f3), GammaP(f1)+Delta(v0,v2)+GammaP(f2), GammaP(f2)+Delta(v0,v3)+GammaP(f3)];
facerowv = [Kappa(f1), Kappa(f2), Kappa(f3)];
edgem = [diffovernorm(v0,v1); diffovernorm(v0,v2); diffovernorm(v0,v3)];
facem = [avgdiff(v1,v2); avgdiff(v2,v3); avgdiff(v3,v1)];
r = -(edgerowv*edgem + facerowv*facem);
end
%%
%handy functions for simplifying matrix multiplication above
function r = GammaP(fn)
r = fn.Gamma*fn.Perimeter;
end

function r = Delta(v0,vn)
[~,IA,~] = intersect(v0.Edge, circshift(vn.Edge, 1, 2),'rows');%note that IA and IB are not necessarily the same
r = v0.Delta(IA);
end
    
function r = Kappa(fn)
r = fn.K*(fn.Area-fn.A0);
end

function r = diffovernorm(v0,vn)
r = (v0.Loc-vn.Loc)./norm(v0.Loc-vn.Loc);
end

function r = avgdiff(v1,v2)
r = 0.5*[v2.Loc(2)-v1.Loc(2),v1.Loc(1)-v2.Loc(1)];
end
%%
function [r,v] = ccwindex(vindex,f,v,width,height)
%move vertex coordinates for non-neighboring simplices
neighbor_face_list = v(vindex).N_Face;
centroids = zeros(3,2);
for i = 1:3
    centroids(i,:) = f(neighbor_face_list(i)).Centroid;
end
diffc = [centroids(2,:)-centroids(1,:);centroids(3,:)-centroids(1,:)];
diffc = vround(diffc,width,height);
for i = 1:2
    vertex = f(neighbor_face_list(i+1)).Vertices;
    for j = 1:length(vertex)
        v(vertex(j)).Loc = v(vertex(j)).Loc - diffc(i,:);
        centroids(i+1,:) = centroids(i+1,:) - diffc(i,:);
    end
end
intersect_vertex = intersect(f(neighbor_face_list(2)).Vertices, f(neighbor_face_list(3)).Vertices);
if ~isempty(intersect_vertex)
    for i = 1:length(intersect_vertex)
        v(intersect_vertex(i)).Loc = v(intersect_vertex(i)).Loc + diffc(i,:);
    end
end
e = edge(v(vindex));
location = loc(v(e));
if polyarea(location) > 0
    circlev = [e(1),e(2),e(3)];
else
    circlev = [e(1),e(3),e(2)];
end
if polyarea(centroids) > 0
    circlef = [neighbor_face_list(1),neighbor_face_list(2),neighbor_face_list(3)];
else
    circlef = [neighbor_face_list(1),neighbor_face_list(3),neighbor_face_list(2)];
    centroids(2:3,:) = circshift(centroids(2:3,:),1);
end
%circlef store simplex indices, c store coordinates
index = 0;
for i = 1:3
    A = [v(circlev(2)).Loc-v(circlev(1)).Loc; centroids(i,:)-v(circlev(1)).Loc];
    if det(A)<0
        index = i;
        break
    end
end
switch index
    case 1
        circlef = circshift(circlef,0);
    case 2
        circlef = circshift(circlef,-1);
    case 3 
        circlef = circshift(circlef,1);
end
r(1)=circlev(1);
r(2)=circlef(1);
r(3)=circlev(2);
r(4)=circlef(2);
r(5)=circlev(3);
r(6)=circlef(3);
end
%%
function r = polyarea(location)
a1 = location(1:2,:);
a2 = location(2:3,:);
a3 = circshift(location,1);
a3 = a3(1:2,:);
r = det(a1)+det(a2)+det(a3);
end