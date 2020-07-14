function c = coordreset(c)
%COORDRESET Resets the context c's coordinate system.

n = cg(c,'d.n');

c = cs(c,'ac.basis',eye(n),0);
c = cs(c,'ac.origin',zeros(n,1),0);
c = cs(c,'ac.useMomentum',0,0);
end

