function [phi,y,c,sol] = stm(tspan,y0,c,varargin)
%STM Calculates and returns the "trajectory" of state transition matrices
%over the tspan provided for the trajectory in the equations of motion with
%initial condition y0 (expressed as a vertical vector). The third dimension
%of phi is used to obtain the result at different times. If a first
%optional argument (a function handle specifying alternate equations of
%motion) is provided, the alternate symbolic equations of motion will be
%used instead of d.eqns. If a second optional argument stmOrder is
%provided, the state transition tensors up to order stmOrder will be
%calculated so that phi will be a cell array containing each tensor. If two
%output arguments are provided, y, the result of integrating y0 in the
%equations of motion, will also be provided. If three output arguments are
%added, a potentially modified context object (due to caching) will also be
%included. STM does not currently account for event handling or switching
%equations of motion on the fly; that feature may or may not be added in
%the future.

n = getnExtended(c);

if nargin >= 4 && ~isempty(varargin{1})
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

if nargin >= 5
    stmOrder = varargin{2};
else
    stmOrder = 1;
end

[STMEqns,c] = getFromCache(c,'ca.STMHandle',...
              @(eq,context)getSTMEqnsHandle(eq,context,stmOrder),eqns,c);

%These are the relevant initial conditions
ics = [y0; reshape(eye(n),[n^2 1]); ...
       cell2mat(arrayfun(@(k)zeros(n^k, 1),3:stmOrder+1,...
                                           'UniformOutput',false)')];        
          
sol = integ(tspan,ics,c,STMEqns);

%if we can't actually satisfy the tspan, we go for the next best thing
try
soly = deval(sol,tspan);
catch exception
    if strcmp(exception.identifier,'MATLAB:deval:SolOutsideInterval')
        soly = deval(sol,sol.x);
    end
end
y = soly(1:n,:);

if stmOrder == 1
    phi = reshape(soly(n+1:n+n^2,:),n,n,[]);
else
    phi = {reshape(soly(n+1:n+n^2,:),n,n,[])};
end

if stmOrder >= 2
    phi{2} = reshape(soly(n^2+n+1:n^3+n^2+n,:),n, n, n,[]);
end

end

