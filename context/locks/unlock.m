function c = unlock(c,p)
%REMOVELOCK Removes a lock for the namespace/property path p in the context
%c. For example, to unlock all parameters, call c = unlock('p',c). To 
%unlock the equations of motion, call c = unlock('d.eqns',c).

%We intentionally avoid using cg and cs to edit locks because otherwise you
%could lock yourself out of c.locks. Note that if the lock you're trying
%to unlock doesn't exist, unlock will do nothing.

c.locks.value(strcmp(p,c.locks.value)) = [];

end

