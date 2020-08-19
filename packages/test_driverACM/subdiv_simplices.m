function P = subdiv_simplices(S,k)
%SUBDIV_SIMPLICES Subdivides a set of d-simplices expressed as a
%three-dimensional array S k times using subdiv_simplex. Please see 
%notice.txt in this folder.

%We have to get the dimension of S
d = size(S,1);
    
%Because we're using a parfor loop, we need to store the subdivided
%simplexes separately in a 4D array at first.

P4D = zeros([size(S,1:3) k^d]);
parfor i = 1:size(S,3)
    P4D(:,:,i,:) = subdiv_simplex(S(:,:,i),k);
end
    
%We now reshape P into the proper format.
P = reshape(P4D,size(S,1:3).*[1 1 k^d]);

end

