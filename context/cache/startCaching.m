function c = startCaching(c)
%STARTCACHING Sets the appropriate properties and locks needed for caching
%(this process includes unlocking the cache). 

%We unlock the cache.
c = unlock(c,'ca');

%We lock the parameters, the dynamics, and the active coordinate system
%when caching starts.
c = lock(c,'p');
c = lock(c,'d');
c = lock(c,'ac');

end

