function newexpr = standard2newsym(expr,p,o,standcoords,newcoords)
%NEW2STANDARDSYM Converts a symbolic expression newexpr (without regard to
%dimension) via basis p and origin o to new coordinates.

newsubexpr = new2standard(newcoords,p,o);
newexpr = subs(expr,standcoords,newsubexpr);
end

