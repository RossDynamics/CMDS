function c = solveDynamics(c)
%SOLVEDYNAMICS A function that conveniently encapsulates the process of
%calculating the dynamics in the current context c, starting from a kinetic
%and a potential. If you want to start from a Hamiltonian instead, use
%solveDynamicsFromH.

%For simplicity, we perform the below analysis in standard coordinates.
c = coordreset(c);

c = TU2L(c);
c = L2qdot2p(c);
c = LHc2H(c);
c = HQ2eqns(c);

end

