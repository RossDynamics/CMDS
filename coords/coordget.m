function varargout = coordget(c)
% COORDGET If no output arguments are provided, prints the basis, origin,
%and coordinate type of the current coordinate system in the context c.
%If one output argument is provided, returns the entire c.ac struct, which
%can be saved and used later.

if nargout == 0
    disp('Current basis (relative to standard coordinates):')
    disp(cg(c,'ac.basis'))
    disp('Current origin (relative to standard coordinates):')
    disp(cg(c,'ac.origin'))

    if cg(c,'ac.useMomentum')
       disp('Using momentum coordinates.'); 
    else
       disp('Using velocity coordinates.');
    end
elseif nargout >= 1
    %We use cg with assumeStruct = false to obtain the coordinate struct.
    varargout{1} = cg(c,'ac',false);
end
end

