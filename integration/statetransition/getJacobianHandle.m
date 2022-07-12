function jacobianHandle = getJacobianHandle(eqns,c,varargin)
%GETJACOBIANHANDLE Creates a function handle in the current coordinate
%system and parameter set that can be evaluated to obtain the Jacobian at a
%point. eqns are symbolic equations of motion that use the same format as 
%d.eqns. Be sure that the derivatives are on the left side of the equations
%of motion and that everything else is on the right side. If an optional
%argument derivativeOrder is provided, CMDS will instead calculate the 
%tensor of order (derivativeOrder + 1) whose entries are the comprised of
%the derivativeOrder-th partial derivatives of the equations. For example, 
%derivativeOrder = 2 corresponds to an n by n by n matrix containing the
%second partial derivatives of the right hand side of the equations of
%motion.

if nargin >= 3
    derivativeOrder = varargin{1};
else
    derivativeOrder = 1;
end

%We don't want to get the base n because it might vary.
n = getnExtended(c);

%We get a function handle for the equations of motion
f = getEquationsHandle(eqns,c);

syms t
syms y [n 1]

%The previous iterate which we need to differentiate
prevIter = f(t,y);

for i = 1:derivativeOrder

    %Because gradient doesn't work on vectors, we have to use arrayfun
    jacobianCell = arrayfun(@(fi)gradient(fi,y).',prevIter,'UniformOutput',false);
    
    %For derivativeOrder >= 2, this will return a matrix which we will need
    %to reshape
    jacobianSymMat = cell2sym(jacobianCell);
    
    jacobianSym = reshape(jacobianSymMat,repelem(n,i+1));
    
    jacobianHandle = matlabFunction(jacobianSym,'Vars',{t,y});
    
    prevIter = jacobianSym;
end

end

