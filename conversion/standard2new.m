function vnew = standard2new(v,p,o)
%STANDARD2NEW Converts a set of vertically represented vectors
%{v1,v2,v3,...} represented as v = [v1 v2 v3 ...] from the standard
%coordinate system used by context objects into the new coordinate system
%with basis conversion matrix (such as a matrix of eigenvectors for an
%eigenbasis) p and origin o. The change of origin is applied before the
%change of basis. Use standard2newmat for converting true
%matrices (such as A matrices) to a new eigenbasis. For simplicity,
%does NOT convert between velocity and momentum coordinates; use qdotp
%instead.
vnew = p \ (v - o);

end