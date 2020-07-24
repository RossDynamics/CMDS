function [STMEqnsHandle,c] = getSTMEqnsHandle(eqns,c)
%GETSTMEQNSHANDLE Obtains the equations necessary for integrating a state
%transition matrix within the current context c. eqns are symbolic 
%equations of motion that use the same format as d.eqns.

n = cg(c,'d.n');

%We get the handles for the equations of motion and the Jacobian
[eqnsFun,c] = getFromCache(c,'ca.eqnsHandle',...
                               @getEquationsHandle,eqns,c);
[jacobianFun,c] = getFromCache(c,'ca.jacobianHandle',...
                               @getJacobianHandle,eqns,c);

    function ydot = STMhandle(t,y)
        %We split y into trajectory and state transition matrix parts
        x = y(1:n);
        phi = reshape(y(n+1:end),[n n]);
        
        %We evaluate the separate equations of motion
        xdot = eqnsFun(t,x);
        phidot = jacobianFun(t,x) * phi;
        
        ydot = [xdot; reshape(phidot,[n^2 1])];
    end

STMEqnsHandle = @STMhandle;

end