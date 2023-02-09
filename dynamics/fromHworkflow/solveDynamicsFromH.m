function c = solveDynamicsFromH(c)
%SOLVEDYNAMICS A function that conveniently encapsulates the process of
%calculating the dynamics in the current context c, starting from a
%Hamiltonian.

%We start in momentum coordinates
c = coordreset(c);
c = useMomentum(c);

%Depending on whether a Legendre transformation override was set before
%solving the dynamics, we may or may not calculate the Legendre
%transformation and the Lagrangian
if ~cg(c,'s.ac.overrideLegendre')
    c = H2qdot2p(c);
    c = H2L(c);
end
c = HQ2eqns(c);

end

