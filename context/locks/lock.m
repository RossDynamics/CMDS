function c = lock(c,p)
%LOCK Adds a lock for the namespace/property path p to the context c.
%For example, to lock all parameters, call c = lock('p',c). To lock the
%equations of motion, call c = lock('d.eqns',c).

%We intentionally avoid using cg and cs to edit locks because otherwise you
%could lock yourself out of c.locks. We also check before adding a lock to
%be sure that the lock doesn't already exist.
if ~any(strcmp(p,c.locks.value))
    c.locks.value{end+1} = p;
end
end

