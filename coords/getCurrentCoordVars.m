function coords = getCurrentCoordVars(c)
%GETCURRENTCOORDVARS Returns the array of coordinate names ([q qdot].' or 
%[q p]') currently active. This function is why, even if you have 
%s.ac.overrideLegendre set to true, you should still set the active
%variables.

useMomentum = cg(c,'ac.useMomentum');
if useMomentum
   coords = [cg(c,'d.q'); cg(c,'d.p'); cg(c,'d.ev')]; 
else
   coords = [cg(c,'d.q'); cg(c,'d.qdot'); cg(c,'d.ev')];
end

end

