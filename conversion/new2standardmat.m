function m = new2standardmat(mnew,p)
%STANDARD2NEWMAT Converts a matrix A from a basis represented by matrix p
%to a new basis.

mnewrows = size(mnew,1);
prows = size(p,1);

%We pad p with identity matrices if it needs to be extended.
p = [p                              zeros(prows, mnewrows - prows)
     zeros(mnewrows - prows, prows) eye(mnewrows - prows)];

try
    m = p * mnew / p;
catch exception
    if strcmp(exception.identifier,'MATLAB:dimagree')    
        ME = MException('CMDS:invalidMatrixSize', ...
        ['mnew cannot be converted. '...
         'Make sure mnew is square and that it does not have '...
         'fewer rows than p.']);
        throw(ME);
    else
        rethrow(exception)
    end
end   

end

