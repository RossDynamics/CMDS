function sol = integ(tspan,y0,c)
%INTEG Integrates a trajectory with initial condition y0
%(expressed as a vertical vector) over the tspan provided
%using the equations, parameters, and settings in the context c. Returns
%a solution struct sol directly from the integrator.

eqns = cg(c,'d.eqns');

options = cg(c,'s.i.odeopts');
integrator = cg(c,'s.i.integrator');

%We get the numerically integrable function handle corresponding to the
%equations of motion
eqnsHandle = getEquationsHandle(eqns,c);

sol = integrator(eqnsHandle,tspan,y0,options);