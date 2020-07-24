function [res,c] = energyplot(tspan,y0,c,varargin)
%ENERGYPLOT Integrates a trajectory with initial condition y0 via integ
%over the provided tspan and plots the energy of the result trajectory. If
%a first extra input argument is provided, ENERGYPLT will use an alternate
%function handle for calculating the energy (provide [] if you don't want
%to override the default). If a second extra input
%argument is provided, ENERGYPLOT will use the truth value provided to
%determine whether to also display the trajectory that was integrated via
%cplot. If a third extra input argument is provided, ENERGYPLOT will pass
%the lineSpec provided at that argument to the energy plotter. If a fourth
%extra input argument is provided, energyplot will pass a second lineSpec
%to the trajectory displayer (only if one is requested). energyplot returns
%a struct that contains the integ sol struct, the energies, and handles
%to the plots. To allow for caching, it may also return a modified context
%object.

if nargin == 4
    energyHandle = varargin{1};
    showTraj = false;
    energyLineSpec = '';
    trajLineSpec = '';
elseif nargin == 5
    energyHandle = varargin{1};
    showTraj = varargin{2};
    energyLineSpec = '';
    trajLineSpec = '';
elseif nargin == 6
    energyHandle = varargin{1};
    showTraj = varargin{2};
    energyLineSpec = varargin{3};
    trajLineSpec = '';
elseif nargin == 7
    energyHandle = varargin{1};
    showTraj = varargin{2};
    energyLineSpec = varargin{3};
    trajLineSpec = varargin{4};
else
    energyHandle = getFromCache(c,'ca.energyHandle',@getEnergyHandle,c);
    showTraj = false;
    energyLineSpec = '';
    trajLineSpec = '';
end

if isempty(energyHandle)
    energyHandle = getFromCache(c,'ca.energyHandle',@getEnergyHandle,c);
end

[sol,c] = integ(tspan,y0,c);
y = deval(sol,tspan);
energies = zeros(1,numel(tspan));

for i=1:numel(tspan)
    energies(i) = energyHandle(tspan(i),y(:,i));
end

energyplot = plot(tspan,energies,energyLineSpec);

res = struct;
res.sol = sol;
res.energies = energies;
res.energyplot = energyplot;
if showTraj
    figure
    trajplot = cplot(y,c,trajLineSpec);
    res.trajplot = trajplot;
end

end

