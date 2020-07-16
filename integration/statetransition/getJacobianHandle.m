function jacobianHandle = getJacobianHandle(eqns,c)
%getJacobianHandle Creates a function handle in the current coordinate
%system and parameter set that can be evaluated to obtain the Jacobian at a
%point. eqns are symbolic equations of motion that use the same format as 
%d.eqns. Be sure that the derivatives are on the left side of the equations
%of motion and that everything else is on the right side.

n = cg(c,'d.n');

%We get a function handle for the equations of motion
f = getEquationsHandle(eqns,c);

syms t
syms y [n 1]

symf = f(t,y);

%Because gradient doesn't work on vectors, we have to use arrayfun
jacobianCell = arrayfun(@(fi)gradient(fi,y).',symf,'UniformOutput',false);

jacobianHandle = matlabFunction(cell2sym(jacobianCell),'Vars',{t,y});

end

