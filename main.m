clear
clc
close all

%[f,v,width,height] = construct_object('./HardcorePackingData/HardPacking.mat'); %choose the file for constructing initial periodic packing state
[f,v,width,height] = construct_object('./RegularPackingData/HexagonalPacking10.mat');

[f,v] = update_simplex_parameter(f,v); %i.e. Area Perimeter VertexOrientation
v = find_dual_vertex(v,width,height);
v = derive_vertex_based_topology(f,v);

A = edge_traversal_list(v);
[F,V,frame]=simulation(f,v,width,height,A);


