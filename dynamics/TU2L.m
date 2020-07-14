function c = TU2L(c)
%TU2L Calculates the Lagrangian from the kinetic and potential energies
%in the current context and returns a new context. 
%Be sure that the kinetic and potential energies already exist in the
%current context.
T = cg(c,'d.T');
U = cg(c,'d.U');
c = cs(c,'d.L',simplify(T-U));
end

