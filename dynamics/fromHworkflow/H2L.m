function c = H2L(c)
%H2L Calculates the Lagrangian for the system in the current context c
%from the Hamiltonian. Be sure to set the active variables via 
%variableNames.

q = cg(c,'d.q');
qdot = cg(c,'d.qdot');
p = cg(c,'d.p');

% try
%     Hc = cg(c,'d.Hc');
% catch exception
%     if strcmp(exception.identifier, 'MATLAB:nonExistentField')
%         %If Hc was never set, just set it to 0.
%         Hc = 0;
%     else
%         rethrow(exception)
%     end    
% end

c = useMomentum(c);

L = sum(qdot.*p) - cg(c,'d.H');

c = cs(c,'d.L',simplify(L));

c = useVelocity(c);

end

