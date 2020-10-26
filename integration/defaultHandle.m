function eqnsHandle = defaultHandle(c)
    %A function for retrieving the default handle from the cache.
    eqns = cg(c,'d.eqns');
    %If the function handle hasn't been cached in this caching
    %session, we have to recalculate it.
    eqnsHandle = getEquationsHandle(eqns,c);
end

