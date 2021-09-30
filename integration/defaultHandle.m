function eqnsHandle = defaultHandle(c)
    %A function for retrieving the default handle if it has not been
    %cached.
    eqns = cg(c,'d.eqns');
    %If the function handle hasn't been cached in this caching
    %session, we have to recalculate it.
    eqnsHandle = getEquationsHandle(eqns,c);
end

