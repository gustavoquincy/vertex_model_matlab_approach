function r = a_force(vindex_vector,f,v,width,height)
if length(vindex_vector)>1
    r = zeros(length(vindex_vector),2);
    %ticBytes(gcp);
    parfor i = 1:length(vindex_vector)
        %try
        r(i,:) = analytic_force(vindex_vector(i),f,v,width,height);
        %catch
            %fprintf('Vertex%d encountered error when calculating force.\n',i);
        %end
    end
    %tocBytes(gcp)
else
    r = analytic_force(vindex_vector,f,v,width,height);
end
end
