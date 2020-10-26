function nExt = getnExtended(c)
%GETNEXTENDED Gets the current dimensionality of the context c's phase
%space. The value nExt given by getnExtended is not necessarily
%equal to the value at c.d.n; they only coincide when the phase space has
%not been extended.

nExt = numel(formula(getCurrentCoordVars(c)));

end

