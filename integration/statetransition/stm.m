function [phi,y] = stm(tspan,y0,c,varargin)
%STM Calculates and returns the "trajectory" of state transition matrices
%over the tspan provided for the trajectory in the equations of motion
%with initial condition y0 (expressed as a vertical vector). The third
%dimension of phi is used to obtain the result at different times.
%If an optional argument (a function handle specifying 
%alternate equations of motion) is provided, the alternate symbolic 
%equations of motion will be used instead of d.eqns. If two output
%arguments are provided, y, the result of integrating y0 in the equations
%of motion, will also be provided. STM does not currently account for event
%handling; that feature may or may not be added in the future.

n = cg(c,'d.n');

if nargin >= 4
    eqns = varargin{1};
else
    eqns = cg(c,'d.eqns');
end

STMEqns = getSTMEqnsHandle(eqns,c);

sol = integ(tspan,[y0; reshape(eye(n),[n^2 1])],c,STMEqns);

soly = deval(sol,tspan);
y = soly(1:n,:);

phi = reshape(soly(n+1:end,:),n,n,[]);

end

