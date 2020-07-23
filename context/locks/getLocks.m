function locks = getLocks(c)
%GETLOCKS Obtains the cell array containing the active locks. 
%Like the other functions for manipulating locks, does not use cs or cg.

locks = c.locks.value;
end

