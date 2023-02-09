%A script that uses the Hamiltonian workflow to generate a system with a
%nonlinear equilibrium point from a cubic Hamiltonian. It then uses this 
%system to test the higher-order state transition tensor calculation
%functionality now included in CMDS.

%We create the context object:
c = Context(2);

syms q(t) qdot(t) p(t) aa bb cc dd

c = variableNames(q,qdot,p,t,c);

H = aa*q^3 + bb*q^2*p + cc*q*p^2 + dd*p^3;

c = cs(c,'d.H',H);

c = cs(c,'s.ac.overrideLegendre',true);
c = solveDynamicsFromH(c);
c = useMomentum(c);

c = cs(c,'p.aa',1);
c = cs(c,'p.bb',20);
c = cs(c,'p.cc',5);
c = cs(c,'p.dd',8);

%We now calculate the linear and quadratic state transition tensors at the
%equilibrium so that they can be compared with the analytical solution.
[phi,y] = stm(linspace(0,1,3),[0 0].',c,[],2);

disp('Calculated linear STT at [0,0]'' from t = 0 to t = 1:')
disp(phi{1}(:,:,end))
disp('Calculated quadratic STT at [0,0]'' from t = 0 to t = 1:')
disp(phi{2}(:,:,:,end))