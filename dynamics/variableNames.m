function c = variableNames(q,qdot,p,t,c)
%VARIABLENAMES Stores the variable names for position (q),
%velocity (qdot), and momentum (p) coordinates for the current context c.
%Also stores the independent variable (t).
%Corresponding coordinates should have corresponding positions in q, qdot,
%and p. For example, if q = [x, y], qdot should be ordered [vx, vy] and
%p should be ordered [px, py].

%Parameters and constants aren't defined here... they follow a different 
%definition flow. Use parameters and constants in your expressions for the
%kinetic energy, potential energy, non-conservative forces, etc. and then
%define properties in c.c and c.p that have the same names. When you need
%to substitute in the parameters, call paramScan to get them.

n = cg(c,'d.n');

%We get the formula forms of the variables--otherwise, the number of
%elements can be miscounted. 
qf = formula(q);
qdotf = formula(qdot);
pf = formula(p);

%We check the variables provided to ascertain whether they are valid
if numel(intersect(qf,qdotf)) || numel(intersect(qf,pf))
    ME = MException('CMDS:invalidVariableList', ...
        'q, qdot, and p cannot have any elements in common.');
   throw(ME);
end

if numel(qf) ~= numel(qdotf) || numel(qf) ~= numel(pf)
    ME = MException('CMDS:invalidVariableList', ...
        'numel(q), numel(qdot), and numel(p) must all be equal.');
    throw(ME);
end

if numel(qf) * 2 ~= n
    ME = MException('CMDS:invalidVariableList', ...
        'The sizes of q, qdot, and p must each be c.d.n / 2.');
    throw(ME);
end

if ~isscalar(t)
    ME = MException('CMDS:invalidVariableList', ...
        'The independent variable must be a scalar.');
    throw(ME);
end

%We convert each set of variables to a column vector in case one was
%specified using an alternate format (such as a row vector)
q = reshape(q,[numel(qf),1]);
qdot = reshape(qdot,[numel(qdotf),1]);
p = reshape(p,[numel(pf),1]);

c = cs(c,'d.q',q,0);
c = cs(c,'d.qdot',qdot,0);
c = cs(c,'d.p',p,0);
c = cs(c,'d.t',t,0);

end

