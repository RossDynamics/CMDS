function c = Context(n)
%CONTEXT Creates and returns an empty context object from n, the
%dimensionality of the desired phase space (without extension). Be sure to
%populate the context object with the proper constants, parameters, etc.
%suitable for your equations of motion using cg and cs. Be sure, similarly,
%to provide T, U, Q, and a constant for offsetting the Hamiltonian. We use
%the getters and setters to ensure that coordinate system-dependent values
%are converted to the active eigenbasis when read.

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
%Changing c.d.n is not recommended! Accessing c.d.n to get the phase space
%dimension is also discouraged. Use getnExtended instead. 
%c.d.n only contains the dimension of the unextended phase space.
c.d.n = Property(n,0);
%The variables/functions representing position coordinates
c.d.q = struct;
%The variables/functions representing velocity coordinates
c.d.qdot = struct;
%The variables/functions representing momentum coordinates
c.d.p = struct;
%The independent variable
c.d.t = struct;
%The variables/functions that extend the phase space; includes
%parameters that are integrated along with the standard equations of 
%motion.
c.d.ev = Property(sym([]),0);
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
%The property alt.eqns[i] represents alternate equations of motion
%with which to continue if the ith event function is terminal and 
%interrupts integration. Symbolic equations and function handles to be 
%passed directly can both be provided. If you don't provide alternate
%equations corresponding to an event function, then integration will simply
%stop as usual. For example, if you want alternate equations to come into
%force for the 1st event function, define alt.eqns1.
c.d.alt = struct;

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
%Settings for the area preservation mapper
c.s.i.ap = struct;
%The volume tolerance to use for comparing simplex volumes before and after
%mapping 
c.s.i.ap.volTol = Property(1e-8,0);

%Output settings
c.s.o = struct;
%Visualization settings (such as settings for trajectory plots)
c.s.o.v = struct;
%The dimension mode to use in functions like integplot
c.s.o.v.dmode = Property('position',0);

%Console settings
c.s.o.c = struct;
%Whether or not to provide progress reports, status reports, etc. 
%in certain operations like volumeMap.
c.s.o.c.isTalkative = Property(true,0);

%Coordinate system settings
c.s.ac = struct;
%If this setting is set to true, CMDS will *completely
%ignore* the standard velocity/momentum coordinates conversion workflow
%that is executed "under the hood" in functions like cs and cg. The
%standard procedure is to store all values in velocity coordinates, but if
%this value is set to true properties can be stored in momentum coordinates
%instead without conversion. The main reason why this setting exists is
%because many systems have Legendre transformations that are
%insufficiently invertible, which in turn gives rise to incorrect results.
%Note that getCurrentCoordVars still needs c.ac.useMomentum to be set to
%the correct value, so you can't ignore that property entirely after
%setting the override.
c.s.ac.overrideLegendre = Property(false,0);

%Other settings
c.s.other = struct;

%A place to store stuff like function handles for the equations of motion
%that are ordinarily recalulated every single time they're used. Note that
%caching should be started using the startCaching function so that the
%appropriate locks will also be set and unset. For similar reasons, it 
%should be unset (and cleared) with the stopCaching function. 
%We don't prepopulate the cache with any properties.
%When clearCache is called, everything will be reverted to the following
%state. The cache is locked unless in use.
c.ca = struct;

%An array of strings denoting locked property names. If a property name or
%a namespace for the provided property is found on this list when 
%attempting to call cs, cs will refuse to write to that property name until
%the lock is removed. As mentioned above, the cache is locked unless in
%use; the cache is the only namespace that's locked by default.
c.locks = Property({'ca'},0);

%Other
c.other = struct;

end

