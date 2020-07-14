function c = LHc2H(c)
%L2H Calculates the Hamiltonian for the system in the current context c
%from the Lagrangian and (optionally) an offset constant for the 
%Hamiltonian. Be sure to set the active variables via variableNames and to
%run L2qdot2p first.

q = cg(c,'d.q');
qdot = cg(c,'d.qdot');
p = cg(c,'d.p');

try
    Hc = cg(c,'d.Hc');
catch exception
    if strcmp(exception.identifier, 'MATLAB:nonExistentField')
        %If Hc was never set, just set it to 0.
        Hc = 0;
    else
        rethrow(exception)
    end    
end

c = useMomentum(c);

H = sum(qdot.*p) - cg(c,'d.L') + Hc;

c = cs(c,'d.H',simplify(H));

c = useVelocity(c);

end

