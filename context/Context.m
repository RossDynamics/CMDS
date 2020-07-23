function c = Context(n)
%CONTEXT Creates and returns an empty context object from n,
%the dimensionality of the desired phase space. Be sure to populate
%the context object with the proper constants, parameters, etc. suitable
%for your equations of motion using cg and cs. Be sure, similarly, to
%provide T, U, Q, and a constant for offsetting the Hamiltonian.
%We use the getters and setters to ensure that coordinate system-dependent
%values are converted to the active eigenbasis when read.

%The substructs within a context are given intentionally terse names
%to make getting and setting seem less verbose.

if mod(n,2)==1 || n <= 0
    ME = MException('CMDS:invalidPhaseSpaceDimension', ...
        'n must be a positive, even number.');
    throw(ME);
end

c = struct;

%Parameters. paramScan searches here.
c.p = struct;

%Dynamics
%Changing c.d.n is not recommended!
c.d.n = Property(n,0);
%The variables/functions representing position coordinates
c.d.q = struct;
%The variables/functions representing velocity coordinates
c.d.qdot = struct;
%The variables/functions representing momentum coordinates
c.d.p = struct;
%The independent variable
c.d.t = struct;
%The vector of equations relating velocity and momentum coordinates
c.d.qdot2p = struct;
%The kinetic energy
c.d.T = struct;
%The potential energy
c.d.U = struct;
%The nonconservative force terms
c.d.Q = struct;
%The constant offset for the Hamiltonian
c.d.Hc = struct;
%The Lagrangian (T - U)
c.d.L = struct;
%The Hamiltonian
c.d.H = struct;
%The governing equations of motion for the system
c.d.eqns = struct;

%Active coordinates. Standard coordinates are active by default.
c.ac.basis = Property(eye(n),0);
c.ac.origin = Property(zeros(n,1),0);
c.ac.useMomentum = Property(0,0);

%Settings
%Integration settings
c.s.i = struct;
%Integration settings to be passed directly to an integrator like ODE113.
%By default, CMDS uses very high tolerance settings.
c.s.i.odeopts = Property(odeset('Reltol',3e-14,'AbsTol',1e-15),0);
%The integrator to use for integration. By default, CMDS uses ode113. If 
%you use a custom solver, make sure it conforms to the same function
%interface as ode113.
c.s.i.integrator = Property(@ode113,0);

%Output settings
c.s.o = struct;
%Visualization settings (such as settings for trajectory plots)
c.s.o.v = struct;
%The dimension mode to use in functions like integplot
c.s.o.v.dmode = Property('position',0);

%Other settings
c.s.other = struct;

%An array of strings denoting locked property names. If a property name or
%a namespace for the provided property is found on this list when 
%attempting to call cs, cs will refuse to write to that property name until
%the lock is removed.
c.locks = Property({},0);

%Other
c.other = struct;

end

