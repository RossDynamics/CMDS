function c = solveDynamicsFromH(c)
%SOLVEDYNAMICS A function that conveniently encapsulates the process of
%calculating the dynamics in the current context c, starting from a
%Hamiltonian.

%We start in momentum coordinates
c = coordreset(c);
c = useMomentum(c);

c = H2qdot2p(c);
c = H2L(c);
c = HQ2eqns(c);

end

