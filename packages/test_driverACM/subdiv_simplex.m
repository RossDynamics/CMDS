function P = subdiv_simplex(S,k)
%SUBDIV_SIMPLICES Subdivides a d-simplex expressed as a matrix of vertical 
%vectors S k times. Outputs a three-dimensional array P containing k^d 
%simplexes; varying the third index yields a matrix of vertical vectors
%expressing a subdivided simplex. d will be automatically calculated from 
%S. Adapted in part from draw_simplices.m. Please see notice.txt in this 
%folder.

d = size(S,1);

%We get the required color schemes
T = simples(k,d);

k = size(T{1},1);

Tsize = max(size(T));

P = zeros(d,d+1,Tsize);

for i = 1:Tsize
  chi = T{i};
  for j = 1:d+1
    for m = 1:k
      P(:,j,i)=P(:,j,i)+S(:,chi(m,j)+1)/k;
    end
  end
end

end

