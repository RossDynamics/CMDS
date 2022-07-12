function [STMEqnsHandle,c] = getSTMEqnsHandle(eqns,c,varargin)
%GETSTMEQNSHANDLE Obtains the equations necessary for integrating a state
%transition matrix within the current context c. eqns are symbolic 
%equations of motion that use the same format as d.eqns. If an optional
%argument stmOrder is provided, the equations for calculating a state
%transition tensor of order stmOrder will instead be provided. The highest
%order currently permitted is stmOrder = 2; for context, the standard state
%transition matrix is the state transition tensor with order 1.

n = getnExtended(c);

if nargin >= 3
    stmOrder = varargin{1};
else
    stmOrder = 1;
end

%We get the handles for the equations of motion and the Jacobian
[eqnsFun,c] = getFromCache(c,'ca.eqnsHandle',...
                               @getEquationsHandle,eqns,c);
                           
jacobians = {};
                           
%We cache the handles for the Jacobians. Note that the first order Jacobian
%used to be cached under ca.jacobianHandle, which is no longer the case; 
%this alteration is not expected to break anything.
for i = 1:stmOrder
    [jacobian,c] = getFromCache(c,...
                   ['ca.jacobian' int2str(i) 'Handle'],...
                  @(eq,context)getJacobianHandle(eq,context,i),eqns,c);
    jacobians{i} = jacobian;
end

                           
    function ydot = STMhandle(t,y)
        %We split y into trajectory and state transition matrix parts
        x = y(1:n);
        phi = reshape(y(n+1:n^2+n),[n n]);
        
        %We evaluate the separate equations of motion
        xdot = eqnsFun(t,x);
        phidot = jacobians{1}(t,x) * phi;
        ydot = [xdot; reshape(phidot,[n^2 1])];
            
        if stmOrder >= 2
            phi2 = tensor(reshape(y(n^2+n+1:n^3+n^2+n),[n n n]));
            phi2dot = ttt(tensor(jacobians{1}(t,x)),phi2,2,1) + ...
                      ttt(ttt(tensor(jacobians{2}(t,x)),tensor(phi),2,1),...
                      tensor(phi),3,1);
            
            ydot = [ydot; reshape(double(phi2dot),[n^3 1])];
        end 
        
        
        
    end

STMEqnsHandle = @STMhandle;

end