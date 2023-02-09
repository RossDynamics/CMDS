function newexpr = standard2newsym(expr,p,o,standcoords,newcoords)
%NEW2STANDARDSYM Converts a symbolic expression newexpr (without regard to
%dimension) via basis p and origin o to new coordinates.

newsubexpr = new2standard(newcoords,p,o);
%When converting a symbolic expression, we simplify to the simplest
%possible form. Using IgnoreAnalyticConstraints may cause us problems
%in the future but it also fixes problems now, and that's all that matters
newexpr = subs(expr,standcoords,newsubexpr);
end

