function vertex = calc_energy(simplex,vertex)
for i = 1:length(vertex)
    U = zeros(3,3);
    for j = 1:length(vertex(i).N_Face)
        f = vertex(i).N_Face(j);
        U(1,j) = simplex(f).K/2*(simplex(f).Area-simplex(f).A0)^2;
        U(2,j) = simplex(f).Gamma/2*(simplex(f).Perimeter)^2;
    end
    for j = 1:length(vertex(i).Edge)
        U(3,j) = vertex(i).Delta(j)*vnorm(vertex(i).Edge(j,1),vertex(i).Edge(j,2),vertex);
    end
    vertex(i).Energy = U;
end
