function [S0,c] = refinePeriodicOrbit(fdt,bdt,S0,c,varargin)
%REFINEPERIODICORBIT Applies iterateSearchMap repeatedly.

startTol = 1e-14;
tolStep = 1e-2;

%We get the initial value of volTol and save it so that we can restore it
%later.
oldTol = cg(c,'s.i.ap.volTol');

c = cs(c,'s.i.ap.volTol',startTol);

isTalkative = cg(c,'s.o.c.isTalkative');

close all;
pos = figure;
vel = figure;

for i = 1:10
    if isTalkative
        disp('Iteration:')
        disp(i)
    end
    
    %First, we subdivide
    k = 2;
    S0 = subdiv_simplices(S0,k);
    
    %We now attempt to run iterateSearchMap. If no overlap is found, we set
    %the area preservation tolerance volTol to be more stringent and try
    %again.
    while true
        
        disp('Current volume tolerance:')
        disp(cg(c,'s.i.ap.volTol'))
        
        [S0new,maxTol,c,S0,fd,bd] = iterateSearchMap(fdt,bdt,S0,c);

        figure(pos)
        c = cs(c,'s.o.v.dmode','position');
        hold off
        cplot(simplices2points(S0),c,'ob')
        hold on
        cplot(simplices2points(fd),c,'.g')
        cplot(simplices2points(bd),c,'or')
        axis equal
        drawnow
        
        figure(vel)
        c = cs(c,'s.o.v.dmode','velocity');
        hold off
        cplot(simplices2points(S0),c,'ob')
        hold on
        cplot(simplices2points(fd),c,'.g')
        cplot(simplices2points(bd),c,'or')
        axis equal
        drawnow
        
        %If S0new is not empty, we set S0 to S0new and break
        if ~isempty(S0new)
            S0 = S0new;
            if isTalkative
                disp('New S0:')
                disp(S0)
            end
            break;
        end
        
        %Otherwise, we decrease the volume tolerance by multiplying the
        %maximum obtained tolerance (which must be less than the current
        %value of volTol) by tolStep.
        c = cs(c,'s.i.ap.volTol',maxTol*tolStep);
        
        if isTalkative
            disp(['No overlap found. Trying again at more '...
                  'stringent s.i.ap.volTol...'])
        end
    end 
    
    %We decrease the current tolerance by multiplying by tolStep after
    %every iteration.
    c = cs(c,'s.i.ap.volTol',cg(c,'s.i.ap.volTol')*tolStep);
    
end

%We restore the old value of volTol.
c = cs(c,'s.i.ap.volTol',oldTol);

end

