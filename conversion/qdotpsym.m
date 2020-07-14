function expr = qdotpsym(expr,ceqns,current)
%QDOTPSYM Converts a symbolic expression expr between velocity and momentum
%coordinates using the conversion equations ceqns. The current set of 
%velocity or momentum variables must be provided. If
%velocity coordinates are provided, qdotpsym attempts to convert to
%momentum coordinates (and vice versa). Use qdotp for numeric vectors.

ceqnsf = formula(ceqns);
currentf = formula(current);

%Solve won't work with symbolic functions, so we substitute temporary
%variables that replace the symbolic functions first.
syms tempvars [size(currentf) 1]

ceqnsf = subs(ceqnsf,currentf,tempvars);

solution = solve(ceqnsf,tempvars);

if numel(currentf) == 1
    replace = solution(1);
    replace = subs(replace,tempvars,currentf);
    expr = simplify(subs(expr,currentf,replace));
else
    for i = 1:numel(currentf)
        %We use the first solution (which is a possibly simplistic method but
        %will work for simple ceqns).
        replace = solution.(char(tempvars(i)))(1);
        replace = subs(replace,tempvars(i),currentf(i));
        expr = simplify(subs(expr,currentf(i),replace));
    end
end

end

