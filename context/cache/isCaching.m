function result = isCaching(c)
%ISCACHING Returns logical 1 if the cache is active; returns logical 0
%otherwise.

%If the cache is unlocked, we consider it active.
result = ~isLocked('ca',c);

end

