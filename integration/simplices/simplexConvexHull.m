function S = simplexConvexHull(A,U,varargin)
%SIMPLEXCONVEXHULL Given two sets of simplices A and U, where A should be
%a subset of U, returns all of the simplices S in U that are within the
%convex hull of A. If an optional argument, a tolerance, is supplied, it
%will be passed to the inhull function (if it is not supplied, a tolerance
%of 1e-13 will be assumed). Simplices must be specified in the
%standard, three-dimensional CMDS format.

if nargin == 2
    tol = 1e-13;
elseif nargin > 3
    tol = varargin{1};
end

%We convert both simplices to points
Apoints = simplices2points(A);
[Upoints, Upoints2U] = simplices2points(U);

%We determine which points in U are inside the convex hull of the points in
%A
in = inhull(Upoints',Apoints',[],tol);

%Then, we generate an array with Upoints2U that specifies which points in
%which simplices are inside the convex hull
in2D = in(Upoints2U);

%If every point in a simplex is within the convex hull, the simplex is
%within the convex hull.
inSimplices = all(in2D,2);

%We can use inSimplices to determine S.
S = U(:,:,inSimplices);

end

