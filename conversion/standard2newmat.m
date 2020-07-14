function mnew = standard2newmat(m,p)
%STANDARD2NEWMAT Converts a matrix A from the standard basis to a new
%basis represented by matrix p.

mnew = p \ m * p;

end

