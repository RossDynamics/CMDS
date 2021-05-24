function [p,c,sol] = integplot(tspan,y0,c,varargin)
%INTEGPLOT A wrapper function that runs integ and plots the results via
%cplot. Like cplot, integplot can take an optional lineSpec argument.

if nargin >= 4
    lineSpec = varargin{1};
else
    lineSpec = '';
end

[sol,c] = integ(tspan,y0,c);
%By using sol.x to plot, we can get the timesteps used by the solver. Doing
%so is quite important for handling terminal event functions.
y = deval(sol,sol.x);
p = cplot(y,c,lineSpec);

end

