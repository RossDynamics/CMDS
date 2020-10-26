function c = removeIntegratedParameter(param,c)
%ADDINTEGRATEDPARAMETER Unlinks an integrated parameter, transforming it to
%a normal parameter by deleting it from c.d.ev and by deleting the
%corresponding differential equation from c.d.eqns. To add an integrated
%parameter, use addIntegratedParameter.

%We delete the corresponding differential equation, as determined by the
%presence of the term diff(param, t), from c.d.eqns first
t = cg(c,'d.t');
eqns = formula(cg(c,'d.eqns'));

eqns(has(eqns,diff(param,t))) = sym([]);

c = cs(c,'d.eqns',eqns);

%We delete the parameter from c.d.ev
ev = formula(cg(c,'d.ev'));
ev(logical(ev == param)) = sym([]);
c = cs(c,'d.ev',ev);

end

