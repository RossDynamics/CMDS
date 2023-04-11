function c = harmonic_oscillator_context()
%HARMONIC_OSCILLATOR_CONTEXT A constructor/profile for the harmonic
%oscillator that creates a context c.
c = Context(2);

syms q(t) qdot(t) p(t) t m k
c = variableNames(q,qdot,p,t,c);

T = 1/2*m*qdot^2;
U = 1/2*k*q^2;

c = cs(c,'d.T',T); 
c = cs(c,'d.U',U);

c = solveDynamics(c);c
end

