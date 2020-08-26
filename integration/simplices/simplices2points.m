function [pts,pts2S] = simplices2points(S)
%SIMPLICES2POINTS Extracts the unique points from a set of simplices, 
%returning a two-dimensional matrix of vectors pts. May optionally return
%pts2S, an array which specifies how to reconstruct the simplices from the
%unique points. pts2S(i,j) contains the index of the vector in pts that
%corresponds to the jth member of the ith simplex.

%First, we flatten the 3D simplex array
flatS = reshape(S,[size(S,1) size(S,2)*size(S,3)]);

%Now, we get the unique elements of this array
[pts,~,ic] = unique(flatS.','rows');

%We have to transpose pts to put it in the vertical format
pts = pts.';

%We now convert ic, which specifies how to transform pts to flatS, to the
%pts2S format.

pts2S = reshape(ic,size(S,2),[]).';

end

