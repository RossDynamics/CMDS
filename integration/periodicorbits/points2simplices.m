function S = points2simplices(pts,pts2S)
%POINTS2SIMPLICES Converts a set of points pts to a set of simplices S via
%pts2S. pts2S(i,j) contains the index of the vector in pts that
%corresponds to the jth member of the ith simplex.

S = zeros(size(pts,1), size(pts,1)+1, size(pts2S,1));

for i = 1:size(pts2S,1)
    S(:,:,i) = pts(:,pts2S(i,:));
end

end

