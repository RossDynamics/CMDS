function coords = getCurrentCoordVars(c)
%GETCURRENTCOORDVARS Returns the array of coordinate names ([q qdot].' or 
%[q p]') currently active.

useMomentum = cg(c,'ac.useMomentum');
if useMomentum
   coords = [cg(c,'d.q'); cg(c,'d.p')]; 
else
   coords = [cg(c,'d.q'); cg(c,'d.qdot')];
end

end

