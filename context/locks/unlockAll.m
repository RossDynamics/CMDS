function c = unlockAll(c)
%UNLOCKALL Clears all active locks in a context c.
c.locks.value = {};
end

