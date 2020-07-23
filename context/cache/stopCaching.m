function c = stopCaching(c)
%STOPCACHING  Sets the appropriate properties and locks needed for ending 
%caching. We also clear and lock the cache.

c = clearCache(c);
c = lock(c,'ca');

%We unlock the parameters, the dynamics, and the active coordinate system
%when caching ends.
c = unlock(c,'p');
c = unlock(c,'d');
c = unlock(c,'ac');
end

