function v = new2standard(vnew,p,o)
%STANDARD2NEW Converts a set of vertically represented vectors
%{v1,v2,v3,...} represented as vnew = [v1 v2 v3 ...] 
%from a coordinate system with basis conversion matrix (such as a matrix
%of eigenvectors for an eigenbasis) p and origin o (where o and p are
%relative to the standard coordinate system) into the standard coordinate
%system used by context objects. Use new2standardmat for converting true
%matrices (such as A matrices) to the standard eigenbasis. For simplicity,
%does NOT convert between velocity and momentum coordinates; use qdotp
%instead. If size(p,1) or size(o,1) are smaller than v, then p or o,
%respectively, is extended in a way that preserves the extra elements of v.

vnewrows = size(vnew,1);
orows = size(o,1);
prows = size(p,1);

%We pad p with identity matrices if it needs to be extended.
p = [p                              zeros(prows, vnewrows - prows)
     zeros(vnewrows - prows, prows) eye(vnewrows - prows)];

%We pad o with zeros if it needs to be extended.
o = [o
     zeros(vnewrows - orows,1)];

try
    v = p * vnew + o;
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

