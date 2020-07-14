function eqnsnew = diffeqnssimplify(eqns,Y,x)
%EQNSSIMPLIFY Simplifies a system of differential equations eqns where 
%dY/dx = ..., Y is a vector of dependent variables, and x is an
%independent variable.

eqnsf = formula(eqns);

%Solve won't work with symbolic functions, so we substitute temporary
%variables that replace the symbolic functions.
syms tempvars [size(eqnsf) 1]

ceqnsf = subs(eqnsf,diff(Y,x),tempvars);

solution = solve(ceqnsf,tempvars,'ReturnConditions',true);

if numel(eqnsf) == 1
    solutionVec = solution(1);
else
    for i = 1:numel(eqnsf)
        %We use the first solution (which is a possibly simplistic method
        %but will work for simple eqnsf).
        solutionVec(i,1) = solution.(char(tempvars(i)))(1);
    end
end

eqnsnew = diff(Y,x) == simplify(subs(solutionVec,tempvars,diff(Y,x)));

end

