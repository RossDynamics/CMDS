function c = addIntegratedParameter(param,paramEqn,c)
%ADDINTEGRATEDPARAMETER In the context creation workflow for a context c,
%ADDINTEGRATEDPARAMETER is used to link a parameter param (which could be
%called an "integrated parameter") to a differential equation paramEqn
%instead of a constant.  This differential equation is subsequently added
%to the context's equations of motion, thereby extending the phase space
%dimension. As a result, an integrated parameter is exempted from a
%paramScan; however, an initial condition must be supplied for it when
%integrating. To unlink an integrated parameter so that CMDS treats it as a
%normal parameter, use removeIntegratedParameter.
%
%Note: paramEqn must be an ODE. CMDS does not support DAE's at this time.

if any(param == cg(c,'d.ev'))
    ME = MException('CMDS:integratedParameterAlreadyExists', ...
           'An integrated parameter with the same name already exists.');
    throw(ME);
end

%We add the differential equation to c.d.eqns first
c = cs(c,'d.eqns',[cg(c,'d.eqns'); paramEqn]);

%We add the parameter to c.d.ev
c = cs(c,'d.ev',[cg(c,'d.ev'); param]);

end

