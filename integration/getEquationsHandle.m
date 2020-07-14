function eqnHandle = getEquationsHandle(eqns,c)
%GETEQUATIONSHANDLE Processes a symbolic system of first order differential
%equations eqns into a function handle eqnHandle suitable for numerical
%integration. Processing includes substituting in parameters from the
%context c via a paramScan. Be sure that the derivatives are on the left 
%side of eqns and that everything else is on the right side.

eqnsf = formula(eqns);

%We run paramScan on the equations of motion to substitute in any
%parameters
eqnsf = paramScan(eqnsf,c);

rheqnsf = rhs(eqnsf);

%We get the current variables. Because some are themselves functions, we
%have to substitute in new variables for constructing the function
%handle.

q = cg(c,'d.q');
qdot = cg(c,'d.qdot');
p = cg(c,'d.p');
t = cg(c,'d.t');

useMomentum = cg(c,'ac.useMomentum');
if useMomentum
   current = [q; p]; 
else
   current = [q; qdot];
end

syms y [numel(formula(current)),1]

preHandle = subs(rheqnsf,current,y);

%We ensure that 
eqnHandle = matlabFunction(preHandle,'Vars',{t,y});

end

