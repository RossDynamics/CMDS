function p = integplot(tspan,y0,c,varargin)
%INTEGPLOT A wrapper function that runs integ and plots the results via
%cplot. Like cplot, integplot can take an optional lineSpec argument.

if nargin >= 4
    lineSpec = char(varargin(1));
else
    lineSpec = '';
end

sol = integ(tspan,y0,c);
y = deval(sol,tspan);
p = cplot(y,c,lineSpec);

end

