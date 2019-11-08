function qquiver(vindex,f,v,width,height)
loc = v(vindex).Loc;
f = a_force(vindex,f,v,width,height);
quiver(loc(1),loc(2),f(1),f(2));
end
