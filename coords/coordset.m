function c = coordset(c,ac)
%COORDSET Sets the active coordinate system in c to the coordinate struct
%ac, which should have been previously obtained via a call to coordget.

%We write the coordinate system via cs with assumeStruct = false
c = cs(c,'ac',ac,0,false);

end

