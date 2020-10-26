function vnew = standard2new(v,p,o)
%STANDARD2NEW Converts a set of vertically represented vectors
%{v1,v2,v3,...} represented as v = [v1 v2 v3 ...] from the standard
%coordinate system used by context objects into the new coordinate system
%with basis conversion matrix (such as a matrix of eigenvectors for an
%eigenbasis) p and origin o. The change of origin is applied before the
%change of basis. Use standard2newmat for converting true
%matrices (such as A matrices) to a new eigenbasis. For simplicity,
%does NOT convert between velocity and momentum coordinates; use qdotp
%instead. If size(p,1) or size(o,1) are smaller than v, then p or o,
%respectively, is extended in a way that preserves the extra elements of v.

vrows = size(v,1);
orows = size(o,1);
prows = size(p,1);

%We pad p with identity matrices if it needs to be extended.
p = [p                           zeros(prows, vrows - prows)
     zeros(vrows - prows, prows) eye(vrows - prows)];

%We pad o with zeros if it needs to be extended.
o = [o
     zeros(vrows - orows,1)];

try
    vnew = p \ (v - o);
catch exception
    if strcmp(exception.identifier,'MATLAB:dimagree')    
        ME = MException('CMDS:invalidVectorSize', ...
        ['v cannot be converted. '...
         'Make sure v does not have fewer rows than o or p.']);
        throw(ME);
    else
        rethrow(exception)
    end
end   

end