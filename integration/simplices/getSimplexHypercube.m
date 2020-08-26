function S = getSimplexHypercube(n)
%GETSIMPLEXHYPERCUBE Creates a set of n-simplices arranged as a unit
%hypercube.

S = zeros(n,n+1,2^n);

for i = 1:2^n
    %We get the binary representation of i and convert 0's to -1's
    pattern = dec2bin(i-1,n)-'0';
    pattern(pattern==0) = -1;
    
    %We now multiply the pattern to the simplex along the coordinate axes
    S(:,:,i) = [zeros(n,1) eye(n).*pattern];
end

end

