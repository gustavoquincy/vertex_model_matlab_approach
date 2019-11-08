function r = vround(diffmat,width,height)
for i = 1:length(diffmat(:))/2
    diffmat(i) = width_round(diffmat(i),width);
end
for i = length(diffmat(:))/2+1:length(diffmat(:))
    diffmat(i) = height_round(diffmat(i),height);
end
r = diffmat;
end

function r = width_round(argin,width)
if argin<-width/2
    r = -width;
elseif argin>=-width/2 && argin<=width/2
    r = 0;
else
    r = width;
end
end

function r = height_round(argin,height)
if argin<-height/2
    r = -height;
elseif argin>=-height/2 && argin<=height/2
    r = 0;
else
    r = height;
end
end