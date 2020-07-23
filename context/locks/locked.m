function result = locked(c,p)
%LOCKED Determines whether the namespace/property p is subject to any
%active locks in the context c. A property has an active lock if its name 
%or one of its namespaces' names is located in context.locks. 
%For example, c.s.i.odeopts can be locked if 's', 's.i', or 's.i.odeopts'
%is located in context.locks. We want to be sure that if, for instance,
%'s' is locked then 'sa' will not be locked, so we split each property path
%and lock into cell arrays of names. Returns false if p is not locked and
%returns true otherwise.

splitProperty = split(p,'.');
locks = getLocks(c);

result = false;

for i = 1:numel(locks)
    splitLocks = split(locks{i},'.');
    
    %If the length of the lock is longer than the property, the lock can't
    %apply to the property.
    if numel(splitLocks) > numel(splitProperty)
        continue;
    end
    %Suppose a lock is 5 namespaces long. We compare the lock and the
    %property's namespaces 1:5, even if the property has a longer
    %namespace. If these two things are equal, the lock applies.
    if isequal(splitProperty(1:numel(splitLocks)),splitLocks)
        result = true;
        return;
    end
end

end

