function A = edge_traversal_list(v)
A = [];
for i = 1:length(v)
    A = [A;v(i).Edge];
end
A = unique(sort(A,2),'rows');
for i = 1:size(A,1)
    f1 = v(A(i,1)).N_Face;
    f2 = v(A(i,2)).N_Face;
    Uf = union(f1,f2);
    Df1 = setdiff(Uf,f1);
    A(i,3) = Df1;
end
end