function c = uc_harmonic_oscillators_context()
%HARMONIC_OSCILLATOR_CONTEXT A constructor/profile for two uncoupled 
%harmonic oscillators that creates a context c.
c = Context(4);

syms q1(t) q2(t) qdot1(t) qdot2(t) p1(t) p2(t) t m1 k1 m2 k2
c = variableNames([q1 q2],[qdot1 qdot2],[p1 p2],t,c);

T = 1/2*m1*qdot1^2+1/2*m2*qdot2^2;
U = 1/2*k1*q1^2+1/2*k2*q2^2;

c = cs(c,'d.T',T); 
c = cs(c,'d.U',U);

c = solveDynamics(c);
end

