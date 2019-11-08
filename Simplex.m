classdef Simplex
    properties
        Vertices
        Vsize
        Orientation
        Area
        Perimeter
        Centroid
        A0 = 1.5%Optimal Area 
        K = 0.12 %AreaElasticityParameter
        Gamma = 1 %PerimeterContractilityParameter
        CorsonCellState = 0 %CorsonCellState ccs will affect K Gamma Delta as reflected in related function
    end
    methods
        function obj=Simplex(varargin)
            if nargin>0
                obj.Vertices=cell2mat(varargin);
            end
        end
        function [r,l] = ver(obj)
            r = horzcat(obj(:).Vertices);
            l = horzcat(obj(:).Vsize);
        end
        function r = cen(obj)
            r = vertcat(obj.Centroid);
        end
        function r = stateu(obj)
            r = vertcat(obj.CorsonCellState);
        end
    end
end