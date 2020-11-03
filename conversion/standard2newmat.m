function mnew = standard2newmat(m,p)
%STANDARD2NEWMAT Converts a matrix A from the standard basis to a new
%basis represented by matrix p.

mrows = size(m,1);
prows = size(p,1);

%We pad p with identity matrices if it needs to be extended.
p = [p                              zeros(prows, mrows - prows)
     zeros(mrows - prows, prows) eye(mrows - prows)];

try
    mnew = p \ m * p;
catch exception
    if strcmp(exception.identifier,'MATLAB:dimagree')    
        ME = MException('CMDS:invalidMatrixSize', ...
        ['m cannot be converted. '...
         'Make sure m is square and that it does not have '...
         'fewer rows than p.']);
        throw(ME);
    else
        rethrow(exception)
    end
end   

end

