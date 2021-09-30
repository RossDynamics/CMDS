function [p,c,sols] = integplot(tspan,y0,c,varargin)
%INTEGPLOT A wrapper function that runs integ and plots the results via
%cplot. Like cplot, integplot can take an optional lineSpec argument.

if nargin >= 4
    lineSpec = varargin{1};
else
    lineSpec = '';
end

[sols,c] = integ(tspan,y0,c);

%We have to hold, but we will turn it back off if needed.
holdstate = ishold;

%This syntax might seem a little confusing, but it turns out that for can
%iterate over cell arrays...
for sol = sols
    %...but you do have to remove the item from the cell array you get back
    if numel(sols) > 1
        sol = sol{1};
    end
    try
        
        y = deval(sol,tspan);
    catch exception
        
        %By using sol.x to plot, we can get the timesteps used by the solver.
        %Doing so is quite important for handling terminal event functions.
        if strcmp(exception.identifier, 'MATLAB:deval:SolOutsideInterval')
            y = sol.y;
        %This can happen if you use a custom solver, so we just avoid using
        %deval in this case.    
        elseif strcmp(exception.identifier, 'MATLAB:deval:InvalidSolver')
            y = sol.y;
        else
            rethrow(exception)
        end
        
    end
    p = cplot(y,c,lineSpec);
    hold on;
end

if ~holdstate
    hold off
end

