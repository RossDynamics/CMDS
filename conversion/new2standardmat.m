function m = new2standardmat(mnew,p)
%STANDARD2NEWMAT Converts a matrix A from a basis represented by matrix p
%to a new basis.

m = p * mnew / p;

end

