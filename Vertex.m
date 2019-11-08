classdef Vertex
    properties
        Loc %Location coordinate of vertex
        Dual = []%Vertex that is topological equivalent assuming periodic boundary condition
        N_Vertex = [] %neighboring vertex index
        N_Face = []%neighboring face index
        Edge = []%representative edge for energy calculation
        Delta = 1*ones(1,3)%corresponding line tension parameter
        %Energy %3*3 vector, row1,area contribution, neighbor_face 1, 2, 3 respectively, 
               %row 2 perimeter and row 3 cell junction, with edge vertex 1, 2, 3 respectively. 
        %UpdateFlag = false
        
    end
    methods
        function obj = Vertex(valx,valy)
            if nargin>0
                obj.Loc=[valx,valy];
            end
        end
        function obj = add_dual(obj,val)
            obj.Dual = horzcat(obj.Dual, val);
        end
        function obj = add_n_vertex(obj,val)
            obj.N_Vertex = horzcat(obj.N_Vertex,val);
        end
        function obj = add_n_face(obj,val)
            obj.N_Face = unique(horzcat(obj.N_Face,val));
        end
        function obj = set_delta(obj,loc,val)
            obj.Delta(loc) = val;
        end
        function sumU = sumU(obj)
            l = length(obj);
            if l == 1
                sumU = sum(obj.Energy,'all');
            else
                sumU = 0;
                for i = 1:l
                    sumU = sumU + sum(obj(i).Energy,'all');
                end
            end
        end
        function neighbor_set = edge(obj)
            neighbor_set = obj.Edge(:,2)';
        end
        %%
        function obj = set_velocity(obj, force)
            obj.Velocity = force;
        end
        function obj = add_loc(obj,dt)
            obj.Loc_Gradient = [obj.Loc_Gradient; obj.Loc_Gradient(end,:) + dt * obj.Velocity];
            obj.UpdateFlag = true;
        end
        %%
        function r = loc(obj)
            r = vertcat(obj.Loc);
        end
        function obj = setloc(obj,val)
            obj(:).Loc = val;
        end
    end
end