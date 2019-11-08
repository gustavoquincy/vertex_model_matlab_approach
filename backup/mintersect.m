function [S,varargout] = mintersect(varargin)
% [S, iA, iB, iC, ...] = mintersect(A, B, C, ...)
% Returns the data S common to numerical vectors A, B, C..., with no
% repetitions. Output S is in sorted order.
% Return in iA, iB, ... index vectors such that S = A(iA) = B(iB) = ...
%
% Syntax: [...] = mintersect(A, B, C, ..., 'rows')
% A, B, are arrays and must have the same number of column n. 
% MINTERSECT considers each row of input arguments as an entities
% for comparison. S is array of n-columns, each row appears at least once
% in each input array.
%
% See also: intersect, munion
% Author: Bruno Luong <brunoluong@yahoo.com>
s           = varargin(:);
rowflag     = ischar(s{end}) && strcmpi(s(end),'rows');
if rowflag
    s(end) = [];
end
nsets       = size(s,1);
isallrowv   = all(cellfun('size',s,1)==1);
for k = 1:nsets
    sk      = s{k};
    if ~rowflag
        sk = sk(:);
    end
    s{k}    = [sk, k+zeros(size(sk,1),1)];
end
[v,L]       = uniquerow(cat(1,s{:}));
[u,K,J]     = uniquerow(v(:,1:end-1));
tf          = accumarray(J,1)==nsets;
S           = u(tf,:);
if isallrowv
    S = S.';
end
if nargout > 1
    nout  = nargout-1;
    if isempty(S)
        out         = cell(1,nout);
        [out{:}]    = deal([]);
    else
        l           = cellfun('size',s,1);
        i           = cumsum(accumarray(1+cumsum(l),-l)+1);
        iL          = i(L);
        a           = bsxfun(@plus, K(tf), (0:nsets-1));
        out         = num2cell(reshape(iL(a),size(a)),1);
    end
    varargout = out;
end
end % mintersect
%%
function [u,I,J] = uniquerow(a)
% perform [u,I,J] = unique(a,'rows') but without overhead
if size(a,2) == 1
    [b,K] = sort(a,'ascend');
else
    [b,K] = sortrows(a,'ascend');
end
tf = [true; any(diff(b,1,1),2)];
i = find(tf);
u = b(i,:);
if nargout >= 2
    I = K(i);
    if nargout >= 3
        J = double(tf);
        J(K) = cumsum(J);
    end
end
end % uniquerow

