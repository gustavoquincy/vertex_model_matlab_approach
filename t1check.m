function [f,v] = t1check(f,v,width,height,dmin,A)
k = 2;%separation ratio, dsep=k*dmin
for i = 1:length(A) 
    v1 = A(i,1);
    v2 = A(i,2);
    if vnorm(v1,v2,v)<=dmin
        f1 = v(v1).N_Face;
        f2 = v(v2).N_Face;
        Uf = union(f1,f2);
        If = intersect(f1,f2,'stable');
        Df = setdiff(Uf,If);
        Df1 = setdiff(Uf,f1);
        Df2 = setdiff(Uf,f2);
        if f(If(1)).Orientation == -1
            if v1==succeed(f(If(1)).Vertices,v2)
                If1 = If(1);
                If2 = If(2);
            else
                If1 = If(2);
                If2 = If(1);
            end
        else
            if v2==succeed(f(If(1)).Vertices,v1)
                If1 = If(1);
                If2 = If(2);
            else
                If1 = If(2);
                If2 = If(1);
            end
        end
        %TODO: differentiate dual and non-dual scenario for v1,v2
        v1_dset = [v1,v(v1).Dual];
        v2_dset = [v2,v(v2).Dual];
        v2Df1 = intersect(f(Df1).Vertices,v2_dset);
        v1Df2 = intersect(f(Df2).Vertices,v1_dset); 
        v1If2 = intersect(f(If2).Vertices,v1_dset);
        v2If1 = intersect(f(If1).Vertices,v2_dset); 
        v1If1 = intersect(f(If1).Vertices,v1_dset); 
        v2If2 = intersect(f(If2).Vertices,v2_dset); 
        cIf1 = f(If1).Centroid;
        cIf2 = f(If2).Centroid;
        cDf1 = f(Df1).Centroid;
        cDf2 = f(Df2).Centroid;
        if Df1==A(i,3)
            if f(Df1).Orientation == -1
                v21 = succeed(f(Df1).Vertices,v2Df1);
            else
                v21 = precede(f(Df1).Vertices,v2Df1);
            end
            if f(Df2).Orientation == -1
                v12 = succeed(f(Df2).Vertices,v1Df2);
            else
                v12 = precede(f(Df2).Vertices,v1Df2);
            end
            %face topological relations update
            for j = 1:length(v1_dset)
                v(v1_dset(j)).N_Face = union(Df,If1);
            end
            for j = 1:length(v2_dset)
                v(v2_dset(j)).N_Face = union(Df,If2);
            end
            f(If1).Vertices = setdiff(f(If1).Vertices, v2_dset, 'stable');
            f(If1).Vsize = f(If1).Vsize - 1;
            f(If2).Vertices = setdiff(f(If2).Vertices, v1_dset, 'stable');
            f(If2).Vsize = f(If2).Vsize - 1;
            
            if sum(vround(cDf1-cIf2,width,height)~=[0,0]) && v1If2==v1Df2
                v1Df1=length(v)+1;
                v(v1Df1)=v(v1If2);
                v(v1Df1).Dual=v1If2;
                v(v1If2).Dual=v1Df1;
            else
                v1Df1 = v1If2;
            end
            f = insert_vertex(Df1,v2Df1,v1Df1,f);
            if sum(vround(cDf2-cIf1,width,height)~=[0,0]) && v2If1==v2Df1
                v2Df2=length(v)+1;
                v(v2Df2)=v(v2If1);
                v(v2Df2).Dual=v2If1;
                v(v2If1).Dual=v2Df2;
            else
                v2Df2 = v2If1;
            end
            f = insert_vertex(Df2,v1Df2,v2Df2,f);
            
            %vertex location information update
            v = t1CoordinateTransform(v1If1,v2If1,v,k);
            v(v2Df2).Loc = v(v2If1).Loc + vround(cDf2-cIf1,width,height);
            v(v2Df1).Loc = v(v2Df2).Loc + vround(cDf1-cDf2,width,height); %
                
            v(v2If2).Loc = v(v2Df2).Loc + vround(cIf2-cDf2,width,height);
            v(v1Df2).Loc = v(v1If1).Loc + vround(cDf2-cIf1,width,height); %
            v(v1Df1).Loc = v(v1If1).Loc + vround(cDf1-cIf1,width,height);
            %vertex topological information update
            v = add_N_Vertex_mutually(v,v1,v21);
            v = add_N_Vertex_mutually(v,v2,v12);
            v = delete_N_Vertex_mutually(v,v1,v12);
            v = delete_N_Vertex_mutually(v,v2,v21);
            edge_mat = [v1Df1,v21,v12; v21,v1Df1,v2Df1; v2Df2,v12,v21; v12,v2Df2,v1Df2];
            for j = 1:size(edge_mat,1)
                v = replace_Edge_mutually(v,edge_mat(j,1),edge_mat(j,2),edge_mat(j,3));
            end
        else
            if f(Df1).Orientation == -1
                v21 = precede(f(Df1).Vertices,v2Df1);
            else
                v21 = succeed(f(Df1).Vertices,v2Df1);
            end
            if f(Df2).Orientation == -1
                v12 = precede(f(Df2).Vertices,v1Df2);
            else
                v12 = succeed(f(Df2).Vertices,v1Df2);
            end
            for j = 1:length(v1_dset)
                v(v1_dset(j)).N_Face = union(Df,If2);
            end
            for j = 1:length(v2_dset)
                v(v2_dset(j)).N_Face = union(Df,If1);
            end
            f(If1).Vertices = setdiff(f(If1).Vertices, v1_dset, 'stable');
            f(If1).Vsize = f(If1).Vsize - 1;
            f(If2).Vertices = setdiff(f(If2).Vertices, v2_dset, 'stable');
            f(If2).Vsize = f(If2).Vsize - 1;
            
            if sum(vround(cDf1-cIf2,width,height)~=[0,0]) && v1If1==v1Df2
                v1Df1=length(v)+1;
                v(v1Df1)=v(v1If1);
                v(v1Df1).Dual=v1If1;
                v(v1If1).Dual=v1Df1;
            else
                v1Df1 = v1If1;
            end
            %f = insert_vertex(Df1,v2Df1,v1Df1,f);
            if sum(vround(cDf2-cIf1,width,height)~=[0,0]) && v2If2==v2Df1
                v2Df2=length(v)+1;
                v(v2Df2)=v(v2If2);
                v(v2Df2).Dual=v2If2;
                v(v2If2).Dual=v2Df2;
            else
                v2Df2 = v2If2;
            end
            f = r_insert_vertex(Df1,v2Df1,v1Df1,f);
            f = r_insert_vertex(Df2,v1Df2,v2Df2,f);
            
            v = rt1CoordinateTransform(v1If1,v2If1,v,k);
            v(v2Df2).Loc = v(v2If1).Loc + vround(cDf2-cIf1,width,height);
            v(v2Df1).Loc = v(v2Df2).Loc + vround(cDf1-cDf2,width,height);
            v(v2If1).Loc = v(v2Df2).Loc + vround(cIf1-cDf2,width,height);
            v(v1Df2).Loc = v(v1If1).Loc + vround(cDf2-cIf1,width,height);
            v(v1Df1).Loc = v(v1If1).Loc + vround(cDf1-cIf1,width,height);
            v(v1If2).Loc = v(v1If1).Loc + vround(cIf2-cIf1,width,height);
            v = add_N_Vertex_mutually(v,v1,v21);
            v = add_N_Vertex_mutually(v,v2,v12);
            v = delete_N_Vertex_mutually(v,v1,v12);
            v = delete_N_Vertex_mutually(v,v2,v21);
            edge_mat = [v1Df1,v21,v12; v21,v1Df1,v2Df1; v2Df2,v12,v21; v12,v2Df2,v1Df2];
            for j = 1:size(edge_mat,1)
                v = replace_Edge_mutually(v,edge_mat(j,1),edge_mat(j,2),edge_mat(j,3));
            end
        end

    end
end
end
%%   
        
function f = insert_vertex(findex,v0,vin,f)
vertex = f(findex).Vertices;
loc = find(vertex==v0);  
vertex1 = circshift(vertex,length(vertex)-loc);
vertex2 = circshift(vertex,-(loc-1));
if f(findex).Orientation==-1
    vertex1(length(vertex1)+1) = vin;
    vertex = vertex1;
else
    vertex2(length(vertex2)+1) = vin;
    vertex = vertex2;
end
f(findex).Vertices = vertex;
f(findex).Vsize = length(vertex);
end

function f = r_insert_vertex(findex,v0,vin,f)
vertex = f(findex).Vertices;
loc = find(vertex==v0);
vertex1 = circshift(vertex,length(vertex)-loc);
vertex2 = circshift(vertex,-(loc-1));
if f(findex).Orientation==1
    vertex1(length(vertex1)+1) = vin;
    vertex = vertex1;
else
    vertex2(length(vertex2)+1) = vin;
    vertex = vertex2;
end
f(findex).Vertices = vertex;
f(findex).Vsize = length(vertex);
end

function v = add_N_Vertex_mutually(v,v1,v2)
v1_dset = [v1,v(v1).Dual];
v2_dset = [v2,v(v2).Dual];
for i = 1:length(v1_dset)
    v(v1_dset(i)).N_Vertex = union(v(v1_dset(i)).N_Vertex,v2_dset);
end
for i = 1:length(v2_dset)
    v(v2_dset(i)).N_Vertex = union(v(v2_dset(i)).N_Vertex,v1_dset);
end
end

function v = delete_N_Vertex_mutually(v,v1,v2)
v1_dset = [v1,v(v1).Dual];
v2_dset = [v2,v(v2).Dual];
for i = 1:length(v1_dset)
    v(v1_dset(i)).N_Vertex = setdiff(v(v1_dset(i)).N_Vertex,v2_dset);
end
for i = 1:length(v2_dset)
    v(v2_dset(i)).N_Vertex = setdiff(v(v2_dset(i)).N_Vertex,v1_dset);
end
end

function v = replace_Edge_mutually(v,v0,vadd,vminus)
e = v(v0).Edge;
v0_dset = [v0,v(v0).Dual];
vminus_dset = [vminus, v(vminus).Dual];
[~,IA,~] = intersect(e(:,2),vminus_dset);
e(IA,:) = [v0,vadd];
for i = 1:length(v0_dset)
    v(v0_dset(i)).Edge = e;
end
end

function r = precede(vlist,v0)
loc = find(vlist==v0);
vlist = circshift(vlist, length(vlist)-loc);
r = vlist(length(vlist)-1);
end

function r = succeed(vlist,v0)
loc = find(vlist==v0);
vlist = circshift(vlist, -(loc-1));
r = vlist(2);
end

function v = t1CoordinateTransform(v1,v2,v,k)
%ccw rotate v1-v2 vector for 90 degrees
Mat = 0.5*k*[0,-1;1,0];
cadd = (v(v1).Loc + v(v2).Loc)*0.5;
cminus = (v(v1).Loc - v(v2).Loc);
v(v1).Loc = (Mat*cminus' + cadd')';
v(v2).Loc = (Mat'*cminus' + cadd')';
end

function v = rt1CoordinateTransform(v1,v2,v,k)
%cw rotate
Mat = 0.5*k*[0,-1;1,0];
cadd = (v(v1).Loc + v(v2).Loc)*0.5;
cminus = (v(v1).Loc - v(v2).Loc);
v(v1).Loc = (Mat'*cminus' + cadd')';
v(v2).Loc = (Mat*cminus' + cadd')';
end


