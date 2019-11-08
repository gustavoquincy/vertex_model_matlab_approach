function asso_u = associated_u(vindex,simplex,vertex)
asso_u = 0;
face = vertex(vindex).N_Face;
for i = 1:length(face)
    asso_u = asso_u + face_energy(face(i),simplex,vertex);
end
asso_u = asso_u - 2*sumU(vertex(vindex)) - sumU(vertex(vertex(vindex).Edge(:,2)'));
end

function uf = face_energy(findex, simplex, vertex)
    uf= sumU(vertex(simplex(findex).Vertices));
end