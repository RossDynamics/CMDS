function c = H2qdot2p(c)
%H2QDOT2P Calculates the conversion equations between velocity and momentum
%coordinates for the Hamiltonian in the current context c.

qdot = cg(c,'d.qdot');
p = cg(c,'d.p');

H = cg(c,'d.H');

ceqns = qdot == functionalDerivative(H,p);

%d.qdot2p should be an invariant
c = cs(c,'d.qdot2p',simplify(ceqns),0);

end

