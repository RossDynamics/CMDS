function [phi,y,c] = stm(tspan,y0,c,varargin)
%STM Calculates and returns the "trajectory" of state transition matrices
%over the tspan provided for the trajectory in the equations of motion
%with initial condition y0 (expressed as a vertical vector). The third
%dimension of phi is used to obtain the result at different times.
%If an optional argument (a function handle specifying 
%alternate equations of motion) is provided, the alternate symbolic 
%equations of motion will be used instead of d.eqns. If two output
%arguments are provided, y, the result of integrating y0 in the equations
%of motion, will also be provided. If three output arguments are added,
%a potentially modified context object (due to caching) will also be
%included. STM does not currently account for event
%handling; that feature may or may not be added in the future.

n = cg(c,'d.n');

if nargin >= 4
    eqns = varargin{1};
else
    
    %We get the equations of motion again if we're not caching or if we
    %haven't created the STM handle yet
    if ~isCaching(c)
        eqns = cg(c,'d.eqns');
    else
        try
            getfield_nested(c,'ca.STMHandle');
            %We only need the equations is we have to recalculate the
            %handle
            eqns = [];
        catch exception
            if strcmp(exception.identifier,'MATLAB:nonExistentField')
                eqns = cg(c,'d.eqns');
            else
                rethrow(exception)
            end    
        end
    end
end

[STMEqns,c] = getFromCache(c,'ca.STMHandle',@getSTMEqnsHandle,eqns,c);

sol = integ(tspan,[y0; reshape(eye(n),[n^2 1])],c,STMEqns);

soly = deval(sol,tspan);
y = soly(1:n,:);

phi = reshape(soly(n+1:end,:),n,n,[]);

end

