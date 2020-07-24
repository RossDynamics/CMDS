function energyHandle = getEnergyHandle(c,varargin)
%GETENERGYHANDLE Creates a function handle in the current coordinate
%system and parameter set that can be evaluated to obtain the energy at a
%point. If one argument, the context, is provided, getEnergyHandle will
%use d.H to construct a handle. If an additional argument is provided,
%getEnergyHandle will use the additional argument it received as
%the symbolic energy expression.

if nargin == 1
    symbolicEnergy = cg(c,'d.H');
elseif nargin >= 2
    symbolicEnergy = varargin{1};
end

n = cg(c,'d.n');

%We run paramScan first
symbolicEnergy = paramScan(symbolicEnergy,c);

%We get the current variables.

t = cg(c,'d.t');

current = getCurrentCoordVars(c);

syms t
syms y [numel(formula(current)) 1]

%Because some variables are themselves functions, we have to substitute in
%new variables for constructing the function handle.
preHandle = subs(symbolicEnergy,current,y);

energyHandle = matlabFunction(preHandle,'Vars',{t,y});


end

