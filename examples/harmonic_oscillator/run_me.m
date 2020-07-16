%This script is an introductory example to CMDS. It demonstrates
%CMDS functionality, including the automatic dynamics solver and the
%coordinate system converters, using the simple harmonic oscillator.

%%
%First, we create a new context object. The "2" denotes that the phase
%space will be two-dimensional.
c = Context(2);

%%
%We define new symbolic variables for our system using the syms command 
%(from the Symbolic Math Toolbox). Note that our position, velocity,
%and momentum variables must be functions of t; otherwise, the dynamics
%solver won't work properly.

syms q(t) qdot(t) p(t) t m k

%%
%variableNames is a convenient way to store the position, velocity,
%momentum, and independent variables. The unnecessary brackets are
%intentional; in higher DOF problems, arrays of symbolic variables must be
%passed to variableNames. Note that we don't specify the parameters here.
%Also note that variableNames edits the context object, so we must provide
%it as an input argument and an output argument.
c = variableNames([q],[qdot],[p],t,c);

%%
%Using the cs function, we store symbolic expressions for the kinetic and
%potential energies in terms of the above variables.
T = 1/2*m*qdot^2;
U = 1/2*k*q^2;
c = cs(c,'d.T',T); 
c = cs(c,'d.U',U);

%%
%solveDynamics finds the Lagrangian, the Hamiltonian,
%the conversion equation between qdot and p, and the equations of 
%motion.
c = solveDynamics(c);

%Let's print all four of the aforementioned things.
disp('The Lagrangian:')
disp(cg(c,'d.L'))
disp('The Hamiltonian:')
disp(cg(c,'d.H'))
disp('The conversion equations:')
disp(cg(c,'d.qdot2p'))
disp('The equations of motion:')
disp(cg(c,'d.eqns'))

%%
%We need to set the parameters. CMDS will be able to find our value for a
%parameter x if we store it via the property p.x. In this example, we
%choose m = 2 and k = 0.5.
c = cs(c,'p.m',2);
c = cs(c,'p.k',0.5);

%Let's retrieve the parameters to be sure it worked:
cg(c,'p.m');
cg(c,'p.k');

%%
%Notice how merely setting the parameters doesn't overwrite symbolic 
%expressions.
%To substitute parameters into a symbolic expression, one must use the
%paramScan method.
disp('The Hamiltonian without paramScan:')
disp(cg(c,'d.H'))
disp('The Hamiltonian with paramScan:')
disp(paramScan(cg(c,'d.H'),c))

%%
%Let's store and retrieve the numeric vector [1 2]' in the custom property 
%'my.example'.
c = cs(c,'my.example',[1 2]');
disp('my.example:')
disp(cg(c,'my.example'))

%%
%Let's change the origin of the active coordinate system to [1 2]' and then
%try retrieving 'my.example'. 'my.example', in the active coordinate
%system, is now retrieved as [0 0]'! (By the way, to use a new basis [like
%an eigenbasis] set 'ac.basis' instead.)
c = cs(c,'ac.origin',[1 2]');
disp('my.example in the new coordinate system:')
disp(cg(c,'my.example'))

%The Hamiltonian will also be changed:
disp('The Hamiltonian in the new coordinate system:')
disp(cg(c,'d.H'))

%%
%What coordinate system are we in right now? Use coordget to check
coordget(c)

%%
%What happens if we use momentum coordinates?
c = useMomentum(c);
disp('my.example in the new coordinate system:')
disp(cg(c,'my.example'))

disp('The Hamiltonian in the new coordinate system:')
disp(cg(c,'d.H'))

%%
%Let's reset the coordinate system and make sure the reset worked
c = coordreset(c);
coordget(c)

%%
%Let's integrate and plot a trajectory! We'll use 'my.example' as an
%initial condition. Let's plot from t = 0 to t = 15.

integplot(0:0.1:15,cg(c,'my.example'),c)

%We get an ellipse!

%%
%What happens if we rotate phase space via a change of basis? Will the
%integrator still work?

R = @(theta)[cos(theta) -sin(theta)
             sin(theta)  cos(theta)];
         
c = cs(c,'ac.basis',R(pi/3));

integplot(0:0.1:15,cg(c,'my.example'),c)

%It does! Everything rotated accordingly.
%%
%Let's calculate the monodromy matrix for our trajectory, which is actually
%a periodic orbit. The period, as one knows from the general solution for
%the harmonic oscillator) is equal to 2*pi / omega, where omega =
%sqrt(k/m). We use the STM function to calculate the monodromy matrix 
%(since the monodromy matrix is just the state transition matrix of a 
%periodic orbit after one period). Because the STM function returns an
%array of state transition matrices, we get the second slice of the third
%dimension of the result.

period = 2*pi / sqrt(cg(c,'p.k')/cg(c,'p.m'));
disp('Period:')
disp(period)

stmarray = stm([0 period],cg(c,'my.example'),c);
monodromy = stmarray(:,:,2);
disp('Monodromy matrix for this trajectory (using the correct period):')
disp(monodromy)

%Since the entire phase space is foliated by periodic orbits, this result
%for the monodromy matrix is expected.
