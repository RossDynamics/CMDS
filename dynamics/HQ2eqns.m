function c = HQ2eqns(c)
%HQ2EQNS Calculates equations of motion suitable for integration in an
%ode function (like ode113) from the Hamiltonian c.d.H and (optionally) the
%nonconservative force vector c.d.Q (which should have length equal 
%to c.d.n / 2 and which should use momentum coordinates).

c = useMomentum(c);

H = cg(c,'d.H');
n = cg(c,'d.n');

try
    Q = cg(c,'d.Q');
    if numel(Q) ~= n / 2
        ME = MException('CMDS:invalidQVector', ...
        'numel(d.Q) must equal d.n / 2');
        throw(ME);
    end
    Qvec = [zeros(n/2,1) Q];
catch exception
    if strcmp(exception.identifier, 'MATLAB:nonExistentField')
        %If Q was never set, just set it to 0.
        Qvec = zeros(n,1);
    else
        rethrow(exception)
    end    
end

q = cg(c,'d.q');
p = cg(c,'d.p');
t = cg(c,'d.t');

eqns = diff([q; p],t)==Jmatrix(n) * functionalDerivative(H,[q; p]) + Qvec;

c = cs(c,'d.eqns',simplify(eqns));

c = useVelocity(c);

end

