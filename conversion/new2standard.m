function v = new2standard(vnew,p,o)
%STANDARD2NEW Converts a set of vertically represented vectors
%{v1,v2,v3,...} represented as vnew = [v1 v2 v3 ...] 
%from a coordinate system with basis conversion matrix (such as a matrix
%of eigenvectors for an eigenbasis) p and origin o (where o and p are
%relative to the standard coordinate system) into the standard coordinate
%system used by context objects. Use new2standardmat for converting true
%matrices (such as A matrices) to the standard eigenbasis. For simplicity,
%does NOT convert between velocity and momentum coordinates; use qdotp
%instead.

v = p * vnew + o;

end

