function c = L2qdot2p(c)
%L2QDOT2P Calculates the conversion equations between velocity and momentum
%coordinates for the Hamiltonian in the current context c.

qdot = cg(c,'d.qdot');
p = cg(c,'d.p');

L = cg(c,'d.L');

ceqns = p == functionalDerivative(L,qdot);

%d.qdot2p should be an invariant
c = cs(c,'d.qdot2p',simplify(ceqns),0);

end

