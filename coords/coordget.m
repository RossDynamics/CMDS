function coordget(c)
% COORDGET Prints the basis, origin, and coordinate type of the current 
%coordinate system in the context c.

disp('Current basis (relative to standard coordinates):')
disp(cg(c,'ac.basis'))
disp('Current origin (relative to standard coordinates):')
disp(cg(c,'ac.origin'))

if cg(c,'ac.useMomentum')
   disp('Using momentum coordinates.'); 
else
   disp('Using velocity coordinates.');
end

end

