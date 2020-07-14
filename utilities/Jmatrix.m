function j = Jmatrix(n)
%JMATRIX Calculates the n x n canonical symplectic matrix J (where n is the 
%dimensionality of the phase space)

if mod(n,2)==1 || n <= 0
    ME = MException('CMDS:invalidPhaseSpaceDimension', ...
        'n must be a positive, even number.');
    throw(ME);
end

j = [zeros(n/2)  eye(n/2)
     -eye(n/2)  zeros(n/2)];

end

