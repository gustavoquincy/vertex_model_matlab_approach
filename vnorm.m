function r = vnorm(vindex1,vindex2,vertex)
r = norm(vertex(vindex1).Loc-vertex(vindex2).Loc);
end