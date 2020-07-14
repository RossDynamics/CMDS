function expr = new2standardsym(newexpr,p,o,newcoords,standcoords)
%NEW2STANDARDSYM Converts a symbolic expression newexpr (without regard to
%dimension) from basis p and origin o to standard coordinates. 
%For example, if newexpr = nx^2, p = 1_4x4, o = [1 0 0 0].', 
%newcoords = [nx ny nvx nvy].', and standcoords = [x y vx vy]', 
%new2standardsym returns expr = (x-1)^2. 

standexpr = standard2new(standcoords,p,o);
expr = subs(newexpr,newcoords,standexpr);

end

