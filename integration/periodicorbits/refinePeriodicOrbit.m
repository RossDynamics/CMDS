function [S0,c] = refinePeriodicOrbit(fdt,bdt,S0,c,varargin)
%REFINEPERIODICORBIT Applies iterateSearchMap repeatedly.

isTalkative = cg(c,'s.o.c.isTalkative');

for i = 1:5
    if isTalkative
        disp('Iteration:')
        disp(i)
    end
    
    %fdflat = reshape(fd,[size(fd,1) size(fd,2)*size(fd,3)]);
    %bdflat = reshape(bd,[size(bd,1) size(bd,2)*size(bd,3)]);
    
    %intersect(fdflat',bdflat','rows')
    
    [S0new,c,S0,fd,bd] = iterateSearchMap(fdt,bdt,S0,c);
    
    S0flat = reshape(S0,[size(S0,1) size(S0,2)*size(S0,3)]);
    
    c = cs(c,'s.o.v.dmode','position');
    hold off
    cplot(S0flat,c,'.')
    hold on
    cplot(fd,c,'.')
    cplot(bd,c,'.')
    axis equal
    pause
    
    S0 = S0new;
    
    if isTalkative
        disp('New S0:')
        disp(S0)
    end
    
    k = 4;
    d = size(S0,1);
    
    newS0 = zeros([size(S0,1:3) k^d]);
    
    parfor j = 1:size(S0,3)
        newS0(:,:,j,:) = subdiv_simplices(S0(:,:,j),k);
    end
    
    S0 = reshape(newS0,size(newS0,1:3).*[1 1 k^d]);
    
    
end

end

