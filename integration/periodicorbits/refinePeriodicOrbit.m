function [S0,c] = refinePeriodicOrbit(fdt,bdt,S0,c,varargin)
%REFINEPERIODICORBIT Applies iterateSearchMap repeatedly.

startTol = 1e-12;
tolStep = 1e-1;

%We'll use endTol in case we have to "restore" a tolerance.
endTol = [startTol];

%We get the initial value of volTol and save it so that we can restore it
%later.
oldTol = cg(c,'s.i.ap.volTol');

c = cs(c,'s.i.ap.volTol',startTol);

isTalkative = cg(c,'s.o.c.isTalkative');

close all;
pos = figure;
vel = figure;

S0list = {S0};

%We start with 2 because S0list{1} is S0.
i = 2;
while i <= 10
    if isTalkative
        disp('Iteration:')
        disp(i)
    end
    
    %First, we subdivide
    k = 2;
    S0 = subdiv_simplices(S0list{i-1},k);
    
    %We now attempt to run iterateSearchMap. If no overlap is found, we set
    %the area preservation tolerance volTol to be more stringent and try
    %again jattempts times.
    j = 1;
    jattempts = 2;
    while j <= jattempts
        
        disp('Current volume tolerance:')
        disp(cg(c,'s.i.ap.volTol'))
        
        [S0new,maxTol,c,S0,fd,bd] = iterateSearchMap(fdt,bdt,S0,c);

        figure(pos)
        c = cs(c,'s.o.v.dmode','position');
        hold off
        cplot(simplices2points(S0),c,'ob')
        hold on
        cplot(simplices2points(fd),c,'+r')
        cplot(simplices2points(bd),c,'xr')
        if ~isempty(S0new)
            cplot(simplices2points(S0new),c,'ok')
        end
        axis equal
        drawnow
        
        figure(vel)
        c = cs(c,'s.o.v.dmode','velocity');
        hold off
        cplot(simplices2points(S0),c,'ob')
        hold on
        cplot(simplices2points(fd),c,'+r')
        cplot(simplices2points(bd),c,'xr')
        if ~isempty(S0new)
            cplot(simplices2points(S0new),c,'ok')
        end
        axis equal
        drawnow
        
        %If S0new is not empty, we set S0list{i} to S0new, save the
        %current tolerance, and break
        if ~isempty(S0new)
            S0list{i} = S0new;
            endTol(i) = cg(c,'s.i.ap.volTol');
            if isTalkative
                disp('New S0:')
                disp(S0list{i})
                i = i + 1;
            end
            break;
        end
        
                
        j = j + 1;
        
        if j <= jattempts
            %Otherwise, and if we haven't run out of j-attempts, 
            %we decrease the volume tolerance by multiplying the
            %maximum obtained tolerance (which must be less than the current
            %value of volTol) by tolStep.
            c = cs(c,'s.i.ap.volTol',maxTol*tolStep);

            if isTalkative
                disp(['No overlap found. Trying again at more '...
                      'stringent s.i.ap.volTol...'])
            end
        else
            break;
        end
        
    end 
    
    %We decrease the current tolerance by multiplying by tolStep after
    %every iteration.
    c = cs(c,'s.i.ap.volTol',cg(c,'s.i.ap.volTol')*tolStep);
    
    %If we run out of jattempts, we return to the previous iteration.
    if j > jattempts
        if isTalkative
            disp(['Increasing volTol this iteration has not yielded '...
                  'results within ' int2str(jattempts) ' attempts. '...
                  'Returning to previous iteration.'])  
        end
        i = i - 1;
        %We decrease volTol to the saved tolerance at the previous
        %iteration times tolStep
        c = cs(c,'s.i.ap.volTol',endTol(i)*tolStep);
    end
    
end

%We restore the old value of volTol.
c = cs(c,'s.i.ap.volTol',oldTol);

end

