function force = find_force(vindex,simplex,vertex)
tic
[sx1, vx1] = update_energy(vindex, simplex, vertex, 0.01, 0);
ux1 = associated_u(vindex, sx1, vx1);
[sx2, vx2] = update_energy(vindex, simplex, vertex, -0.01, 0);
ux2 = associated_u(vindex, sx2, vx2);
[sy1, vy1] = update_energy(vindex, simplex, vertex, 0, 0.01);
uy1 = associated_u(vindex, sy1, vy1);
[sy2, vy2] = update_energy(vindex, simplex, vertex, 0, -0.01);
uy2 = associated_u(vindex, sy2, vy2);
gradient = [(ux1-ux2)*0.5, (uy1-uy2)*0.5];
force = - gradient;
toc
end