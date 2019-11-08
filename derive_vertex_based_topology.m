%global function for topological relationship derivation
function vertex = derive_vertex_based_topology(simplex, vertex)
l = length(simplex);
for i = 1:l
    for j = i+1:l
        v1 = simplex(i).Vertices;
        v2 = simplex(j).Vertices;
        l1 = length(v1);
        l2 = length(v2);
        for k = 1:l1
            v1 = [v1, vertex(v1(k)).Dual];
        end
        for k = 1:l2
            v2 = [v2, vertex(v2(k)).Dual];
        end
        inter = intersect(v1,v2);
        s = size(inter);
        if s(2)==2
            vertex(inter(1)) = add_n_vertex(vertex(inter(1)),inter(2));
            vertex(inter(2)) = add_n_vertex(vertex(inter(2)),inter(1));
            vertex(inter(1)) = add_n_face(vertex(inter(1)),i);
            vertex(inter(1)) = add_n_face(vertex(inter(1)),j);
            vertex(inter(2)) = add_n_face(vertex(inter(2)),i);
            vertex(inter(2)) = add_n_face(vertex(inter(2)),j);
        end
        if s(2)>2
            for m =1:s(2)
                self = horzcat(vertex(inter(m)).Dual, inter(m));
                diff = setdiff(inter, self);
                for n =1:length(diff)
                    vertex(inter(m)) = add_n_vertex(vertex(inter(m)),diff(n));
                end
                vertex(inter(m)) = add_n_face(vertex(inter(m)),i);
                vertex(inter(m)) = add_n_face(vertex(inter(m)),j);
            end    
        end
    end
end
for iterator = 1:length(vertex)
    if length(vertex(iterator).N_Vertex)==3
        for i = 1:3
            vertex(iterator).Edge(i,:)=[iterator,vertex(iterator).N_Vertex(i)];
        end
    end
    if  isempty(vertex(iterator).Edge)
        dual_set = horzcat(iterator, vertex(iterator).Dual);
        index_out = zeros(6,2);
        loc_out = zeros(6,2);
        for i = 1:3
            face = vertex(iterator).N_Face(i);
            vertex_list = simplex(face).Vertices;
            for j = 1:length(dual_set)
                if ismember(dual_set(j),vertex_list)
                    index = find(vertex_list == dual_set(j));
                    if index<=1
                        index=index+length(vertex_list);
                    end
                    v_pred = vertex_list(index-1);
                    if index>=length(vertex_list)
                        index=index-length(vertex_list);
                    end
                    v_succ = vertex_list(index+1);
                    index_out(2*i-1,:) = [dual_set(j),v_pred];
                    index_out(2*i,:) = [dual_set(j),v_succ];    
                    loc_out(2*i-1,:) = vertex(v_pred).Loc-vertex(dual_set(j)).Loc;
                    loc_out(2*i,:) = vertex(v_succ).Loc-vertex(dual_set(j)).Loc;
                end
            end
        end
        count = 0;
        index_couple = zeros(3,2);
        flag = 0;
        for i = 1:length(loc_out)
            for j = i+1:length(loc_out)
                if abs(loc_out(i,1)-loc_out(j,1))<=1e-10 && abs(loc_out(i,2)-loc_out(j,2))<=1e-10
                    count = count + 1;
                    index_couple(count,:)=[i,j];
                    if count == 3
                        flag = 1;
                        break
                    end
                end
            end
            if flag==1
                break
            end
        end
        location = index_couple(:,1)';
        for i = 1:length(dual_set)
            for j = 1:3
                vertex(dual_set(i)).Edge(j,:)=index_out(location(j),:);
            end
        end
    end
end   
end