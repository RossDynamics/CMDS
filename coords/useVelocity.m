function c = useVelocity(c)
%USEMOMENTUM A convenient way to change to velocity coordinates.
c = cs(c,'ac.useMomentum',0);
end

