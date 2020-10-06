function [sol,c] = integ(tspan,y0,c,varargin)
%INTEG Integrates a trajectory with initial condition y0
%(expressed as a vertical vector) over the tspan provided
%using (by default) the equations, parameters, and settings in the context
%c. Returns a solution struct sol directly from the integrator. 
%If an optional argument (a function handle specifying alternate equations
%of motion) is provided, the alternate equations of motion will be used
%instead of the ones calculated from d.eqns. If an optional output argument
%is provided, integ will return a potentially edited context object (which
%is necessary for caching; putting the eqnsHandle into the cache *will not*
%work unless you can obtain the new context object).

if nargin >= 4
    eqnsHandle = varargin{1};
else
    %integ is only directly responsible for caching the default equations
    %of motion function handles. Custom handles must be cached by the
    %functions that utilize them.
    [eqnsHandle,c] = getFromCache(c,'ca.eqnsHandle',@defaultHandle,c);
    
end

options = cg(c,'s.i.odeopts');
integrator = cg(c,'s.i.integrator');

sol = integrator(eqnsHandle,tspan,y0,options);
end