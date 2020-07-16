function sol = integ(tspan,y0,c,varargin)
%INTEG Integrates a trajectory with initial condition y0
%(expressed as a vertical vector) over the tspan provided
%using (by default) the equations, parameters, and settings in the context
%c. Returns a solution struct sol directly from the integrator. 
%If an optional argument (a function handle specifying alternate equations
%of motion, is provided) the alternate equations of motion will be used
%instead of the ones calculated from d.eqns.

if nargin >= 4
    eqnsHandle = varargin{1};
else
    eqns = cg(c,'d.eqns');
    %We get the numerically integrable function handle corresponding to the
    %equations of motion
    eqnsHandle = getEquationsHandle(eqns,c);
end

options = cg(c,'s.i.odeopts');
integrator = cg(c,'s.i.integrator');

sol = integrator(eqnsHandle,tspan,y0,options);