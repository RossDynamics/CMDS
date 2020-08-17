function volumes = simplexVolume(S)
%SIMPLEXVOLUME Calculates the volumes of a set of simplices S supplied as a
%three dimensional array, where the first two coordinates specify matrices
%of vertical vectors [v1 v2 ...]. %Be sure the vi use momentum
%coordinates!

n = size(S,1);

if n+1 ~= size(S,2)
    ME = MException('CMDS:malformedSimplex', ...
        'There must be n+1 vertical vectors in each n-simplex in S');
    throw(ME);
end

numS = size(S,3);

volumes = zeros(1,numS);

for i=1:numS
    %The formula can sometimes yield negative volumes, so we take the
    %absolute value
    volumes(i) = abs(det(S(:,2:end,i)-S(:,1,i))/factorial(n));
end

end

