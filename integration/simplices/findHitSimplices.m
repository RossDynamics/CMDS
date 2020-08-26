function hitS = findHitSimplices(S,T)
%INTERSECTMAPPING A wrapper for findtria that determines which simplices in
%S were hit by the vertical test points T. INTERSECTMAPPING converts the
%CMDS simplex format to the findtria format and then calls findtria.

flatS = reshape(S,[size(S,1) size(S,2)*size(S,3)]);

%We use unique to get tt and pp for findtria. Note that findtria uses
%horizontal vectors whereas CMDS uses vertical vectors.
[pp,~,tt]=unique(flatS.','rows');

tt = reshape(tt,size(S,2),[]).';

[~,tj]=findtria(pp,tt,T.');

%tj appears to contain the indices of any simplices that were hit
flathitS = pp(tt(unique(tj),:).',:).';

hitS = reshape(flathitS,size(S,1),size(S,2),[]);

end